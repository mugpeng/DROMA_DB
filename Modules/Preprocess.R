tmp <- list()

# Make copy ----
# # PDX
# tavor_drug_raw = tavor_drug
# PDTXBreast_drug_raw = PDTXBreast_drug
# # CellLine
# ccle_drug_raw = ccle_drug
# ctrp1_drug_raw = ctrp1_drug
# ctrp2_drug_raw = ctrp2_drug
# gdsc1_drug_raw = gdsc1_drug
# gdsc2_drug_raw = gdsc2_drug
# gCSI_drug_raw = gCSI_drug
# prism_drug_raw = prism_drug
# FIMM_drug_raw = FIMM_drug
# UHNBreast_drug_raw = UHNBreast_drug
# GRAY_drug_raw = GRAY_drug
# NCI60_drug_raw = NCI60_drug
# # PDO
# UMPDO1_drug_raw = UMPDO1_drug
# UMPDO2_drug_raw = UMPDO2_drug
# UMPDO3_drug_raw = UMPDO3_drug
# # PDX
# Xeva_drug_raw = Xeva_drug

for(i in ls()[grepl("_drug$", ls())]){
  base::assign(paste0(i, "_raw"), base::get(i))
}

drugs_search <- feas_search[feas_search$type %in% "drug",]
omics_search <- feas_search[!feas_search$type %in% "drug",]