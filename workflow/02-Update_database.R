source("function/function.R")

library(DROMA.Set)

load(file = "data/fusion.Rda")
load(file = "data/mut.Rda")

connectDROMADatabase()

# Update fusion data
updateDROMADatabase(CCLE_fusion, table_name = "CCLE_fusion", overwrite = T)

# Update mutation site data
updateDROMADatabase(CCLE_mutation_site, table_name = "CCLE_mutation_site", overwrite = T)
updateDROMADatabase(GDSC_mutation_site, table_name = "GDSC_mutation_site", overwrite = T)

# Update mutation gene data
updateDROMADatabase(CCLE_mutation_gene, table_name = "CCLE_mutation_gene", overwrite = T)
updateDROMADatabase(GDSC_mutation_gene, table_name = "GDSC_mutation_gene", overwrite = T)
updateDROMADatabase(gCSI_mutation_gene, table_name = "gCSI_mutation_gene", overwrite = T)
updateDROMADatabase(Xeva_mutation_gene, table_name = "Xeva_mutation_gene", overwrite = T)
