my_packages <- c("tidyverse", "data.table")
pacman::p_load(char = my_packages)

tmp <- list()

load(file = "data/fusion.Rda")
load(file = "data/mut.Rda")
# preprocess discrete samples ----
# Rename column names to "genes" and "samples"
# Fusion data
if(exists("CCLE_fusion")) {
  colnames(CCLE_fusion) <- c("genes", "samples")
}

# Mutation site data
if(exists("CCLE_mutation_site")) {
  colnames(CCLE_mutation_site) <- c("genes", "samples")
}
if(exists("GDSC_mutation_site")) {
  colnames(GDSC_mutation_site) <- c("genes", "samples")
}

# Mutation gene data
if(exists("CCLE_mutation_gene")) {
  colnames(CCLE_mutation_gene) <- c("genes", "samples")
}
if(exists("GDSC_mutation_gene")) {
  colnames(GDSC_mutation_gene) <- c("genes", "samples")
}
if(exists("gCSI_mutation_gene")) {
  colnames(gCSI_mutation_gene) <- c("genes", "samples")
}
if(exists("Xeva_mutation_gene")) {
  colnames(Xeva_mutation_gene) <- c("genes", "samples")
}

# Save ----
# fusion
save(
  CCLE_fusion,
  file = "data/fusion.Rda"
)

# mut
save(
  gCSI_mutation_gene,
  Xeva_mutation_gene,
  CCLE_mutation_gene, CCLE_mutation_site,
  GDSC_mutation_gene, GDSC_mutation_site,
  file = "data/mut.Rda"
)
