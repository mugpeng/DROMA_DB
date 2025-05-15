library(dplyr)

config_list <- config::get(
  # config = "test"
  # Default is test mode
)

source("Modules/LoadData.R")
source("Back_script/script/function.R")

tmp <- list()

for(i in ls()[grepl("_drug$", ls())]){
  base::assign(paste0(i, "_raw"), base::get(i))
}

# mut data rebuild ----
tmp$tmp2 <- ls()[grepl("_mut$", ls())]
process_mutation_data(tmp$tmp2)

# mut
save(
  gCSI_mutation_gene,
  Xeva_mutation_gene,
  ccle_mutation_gene, ccle_mutation_site,
  gdsc_mutation_gene, gdsc_mutation_site,  
  file = "Input/01/mut.Rda"
)

# search related variables ----
fea_list <- list()
fea_vec <- c("mRNA", "meth", 
             "proteinrppa", 
             "proteinms",
             "cnv", # continuous 
             "drug", # drug
             "drug_raw", # drug_raw
             "mutation_gene", "mutation_site", "fusion" # discrete
)
fea_list <- sapply(fea_vec, function(x){
  # Get all objects with the pattern "_x" (e.g., "_drug")
  i2 <- paste0("_", x)
  i2 <- ls(globalenv())[grepl(i2, ls(globalenv()))]
  
  # Only keep known dataset prefixes to ensure we only get actual datasets
  # This is a whitelist approach which is safer
  known_prefixes <- c("ccle", "gdsc", "gCSI", "ctrp1", "ctrp2", "prism", 
                      "gdsc1", "gdsc2",
                      "FIMM", "GRAY", "NCI60", "UHNBreast", 
                      "tavor", "PDTXBreast",
                      "UMPDO1", "UMPDO2", "UMPDO3", "Xeva")
  
  # Extract the prefix (everything before "_x")
  prefixes <- gsub(paste0("_", x), "", i2)
  
  # Only keep objects with known dataset prefixes
  i2 <- i2[prefixes %in% known_prefixes]
  
  # Extract the dataset name by removing the suffix
  i <- gsub(paste0("_", x), "", i2)
  return(i)
})

## omics and drugs ----
tmp$omics_search_CNV <- data.frame(
  omics = c(rownames(ccle_cnv),
            rownames(gdsc_cnv),
            rownames(gCSI_cnv),
            rownames(Xeva_cnv)
  ),
  type = "cnv"
) %>% unique()


tmp$omics_search_mRNA <- data.frame(
  omics = c(rownames(ccle_mRNA),
            rownames(gdsc_mRNA),
            rownames(NCI60_mRNA),
            rownames(tavor_mRNA),
            rownames(UMPDO1_mRNA),
            rownames(UMPDO2_mRNA),
            rownames(UMPDO3_mRNA),
            rownames(Xeva_mRNA)
  ),
  type = "mRNA"
) %>% unique()

tmp$omics_search_meth <- data.frame(
  omics = c(rownames(ccle_meth)),
  type = "meth"
) %>% unique()

tmp$omics_search_proteinrppa <- data.frame(
  omics = c(rownames(ccle_proteinms)),
  type = "proteinms"
) %>% unique()

tmp$omics_search_proteinms <- data.frame(
  omics = c(rownames(ccle_proteinrppa)),
  type = "proteinrppa"
) %>% unique()

tmp$omics_search_mutgenes <- data.frame(
  omics = c(ccle_mutation_gene$genes,
            gdsc_mutation_gene$genes,
            gCSI_mutation_gene$genes,
            Xeva_mutation_gene$genes
  ),
  type = "mutation_gene"
) %>% unique()

tmp$omics_search_mutsites <- data.frame(
  omics = c(ccle_mutation_site$genes_muts,
            gdsc_mutation_site$genes_muts
  ),
  type = "mutation_site"
) %>% unique()
tmp$omics_search_mutsites <- tmp$omics_search_mutsites[!grepl("noinfo",tmp$omics_search_mutsites$omics),]

tmp$omics_search_fusion <- data.frame(
  omics = c(ccle_fusion$fusion
  ),
  type = "fusion"
) %>% unique()

omics_search <- rbind(
  tmp$omics_search_CNV,
  tmp$omics_search_mRNA,
  tmp$omics_search_meth,
  tmp$omics_search_proteinrppa,
  tmp$omics_search_proteinms,
  tmp$omics_search_fusion,
  tmp$omics_search_mutgenes,
  tmp$omics_search_mutsites
)
omics_search <- unique(omics_search)

# drugs_search2 <- unique(drug_anno[,c(1,2)])
# colnames(drugs_search2) <- c("drugs", "type")

drugs_search <- unique(
  data.frame(
    drugs = unique(drug_anno$DrugName),
    type = "drug"
  )
)

# Combined search 
feas_search <- data.frame(
  name = c(omics_search$omics,
           drugs_search$drugs),
  type = c(omics_search$type,
           drugs_search$type)
)

## samples ----
# Create data frames for CNV data
tmp$cells_search_CNV <- data.frame(
  cells = c(colnames(ccle_cnv),
            colnames(gdsc_cnv),
            colnames(gCSI_cnv),
            colnames(Xeva_cnv)),  # Added Xeva_cnv
  datasets = c(rep("ccle", ncol(ccle_cnv)),
               rep("gdsc", ncol(gdsc_cnv)),
               rep("gCSI", ncol(gCSI_cnv)),
               rep("Xeva", ncol(Xeva_cnv))),  # Added Xeva_cnv
  type = "cnv"
) %>% unique()

# Create data frames for mRNA data
tmp$cells_search_mRNA <- data.frame(
  cells = c(colnames(ccle_mRNA),
            colnames(gdsc_mRNA),
            colnames(NCI60_mRNA),    # Added NCI60_mRNA
            colnames(tavor_mRNA),    # Added tavor_mRNA
            colnames(UMPDO1_mRNA),
            colnames(UMPDO2_mRNA),
            colnames(UMPDO3_mRNA),
            colnames(Xeva_mRNA)),    # Added Xeva_mRNA
  datasets = c(rep("ccle", ncol(ccle_mRNA)),
               rep("gdsc", ncol(gdsc_mRNA)),
               rep("NCI60", ncol(NCI60_mRNA)),    # Added NCI60_mRNA
               rep("tavor", ncol(tavor_mRNA)),    # Added tavor_mRNA
               rep("deng1", ncol(UMPDO1_mRNA)),
               rep("deng2", ncol(UMPDO2_mRNA)),
               rep("deng3", ncol(UMPDO3_mRNA)),
               rep("Xeva", ncol(Xeva_mRNA))),    # Added Xeva_mRNA
  type = "mRNA"
) %>% unique()

# Create data frames for methylation data
tmp$cells_search_meth <- data.frame(
  cells = colnames(ccle_meth),
  datasets = rep("ccle", ncol(ccle_meth)),
  type = "meth"
) %>% unique()

# Create data frames for protein RPPA data
tmp$cells_search_proteinrppa <- data.frame(
  cells = colnames(ccle_proteinrppa),
  datasets = rep("ccle", ncol(ccle_proteinrppa)),
  type = "proteinrppa"
) %>% unique()

# Create data frames for protein MS data
tmp$cells_search_proteinms <- data.frame(
  cells = colnames(ccle_proteinms),
  datasets = rep("ccle", ncol(ccle_proteinms)),
  type = "proteinms"
) %>% unique()

# For mutation gene data
tmp$cells_search_mutgenes <- data.frame(
  cells = c(ccle_mutation_gene$cells,
            gdsc_mutation_gene$cells,
            gCSI_mutation_gene$cells,
            Xeva_mutation_gene$cells),  # Added Xeva_mutation_gene
  datasets = c(rep("ccle", length(ccle_mutation_gene$cells)),
               rep("gdsc", length(gdsc_mutation_gene$cells)),
               rep("gCSI", length(gCSI_mutation_gene$cells)),
               rep("Xeva", length(Xeva_mutation_gene$cells))),  # Added Xeva_mutation_gene
  type = "mutation_gene"
) %>% unique()

# For mutation site data
tmp$cells_search_mutsites <- data.frame(
  cells = c(ccle_mutation_site$cells,
            gdsc_mutation_site$cells),
  datasets = c(rep("ccle", length(ccle_mutation_site$cells)),
               rep("gdsc", length(gdsc_mutation_site$cells))),
  type = "mutation_site"
) %>% unique()

# For fusion data
tmp$cells_search_fusion <- data.frame(
  cells = ccle_fusion$cells,
  datasets = rep("ccle", length(ccle_fusion$cells)),
  type = "fusion"
) %>% unique()

# Combine all cells search data frames
samples_search <- rbind(
  tmp$cells_search_CNV,
  tmp$cells_search_mRNA,
  tmp$cells_search_meth,
  tmp$cells_search_proteinrppa,
  tmp$cells_search_proteinms,
  tmp$cells_search_fusion,
  tmp$cells_search_mutgenes,
  tmp$cells_search_mutsites
)
samples_search <- unique(samples_search)


# save ----
fea_list
omics_search
drugs_search
feas_search
samples_search
save(
  fea_list,
  omics_search, drugs_search, feas_search,
  samples_search,
  file = "Input/05/search_vec.Rda"
)
