my_packages <- c("tidyverse", "data.table")
pacman::p_load(char = my_packages)

tmp <- list()

# Create a SQLite database from data files
createDROMADatabase(db_path = "sql_db/droma.sqlite",
                    rda_dir = "data",
                    # Data store the previous version which are all Rda files
                    projects = NULL) # NULL includes all projects
                    