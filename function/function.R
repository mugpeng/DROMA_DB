#!/usr/bin/env Rscript

#' Create DROMA SQLite Database
#'
#' @description Converts all DROMA data files to a SQLite database with project-oriented structure
#' @param db_path Path where the SQLite database file should be created. Default is "droma.sqlite" in the user's home directory.
#' @param rda_dir Directory containing the Rda files to convert (default is the data directory in the package)
#' @param projects Optional vector of project names to include. If NULL, includes all.
#' @return Invisibly returns the path to the created database
#' @export
#' @examples
#' \dontrun{
#' createDROMADatabase()
#' # Creates a SQLite database with all DROMA data organized by project
#' }
createDROMADatabase <- function(db_path = file.path(path.expand("sql_db"), "droma.sqlite"),
                                rda_dir = "./data",
                                projects = NULL) {
  if (!requireNamespace("RSQLite", quietly = TRUE) ||
      !requireNamespace("DBI", quietly = TRUE)) {
    stop("Packages 'RSQLite' and 'DBI' are required. Please install them with install.packages(c('RSQLite', 'DBI'))")
  }
  # db_path = "sql_db/droma.sqlite"
  # Create database connection
  message("Creating project-oriented database at ", db_path)
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  on.exit(DBI::dbDisconnect(con), add = TRUE)

  # Get all Rda files
  # rda_dir = "data"
  rda_files <- list.files(rda_dir, pattern = "\\.Rda$", full.names = TRUE)

  # First load annotation files
  anno_file <- file.path(rda_dir, "anno.Rda")
  if (file.exists(anno_file)) {
    message("Processing annotations...")
    e <- new.env()
    load(anno_file, envir = e)

    # Write annotation tables
    if (exists("sample_anno", envir = e)) {
      DBI::dbWriteTable(con, "sample_anno", e$sample_anno, overwrite = TRUE)
      message("  - Wrote sample annotations")
    }

    if (exists("drug_anno", envir = e)) {
      DBI::dbWriteTable(con, "drug_anno", e$drug_anno, overwrite = TRUE)
      message("  - Wrote drug annotations")
    }
  }

  # Load search vectors if available
  # search_file <- file.path(rda_dir, "search_vec.Rda")
  # if (file.exists(search_file)) {
  #   message("Processing search vectors...")
  #   e <- new.env()
  #   load(search_file, envir = e)
  #
  #   # Store search vectors as serialized objects
  #   for (obj_name in ls(e)) {
  #     obj <- get(obj_name, envir = e)
  #     if (is.list(obj)) {
  #       df <- data.frame(
  #         name = obj_name,
  #         value = I(list(serialize(obj, NULL))),
  #         stringsAsFactors = FALSE
  #       )
  #       DBI::dbWriteTable(con, "search_vectors", df, append = TRUE)
  #       message("  - Stored search vector: ", obj_name)
  #     }
  #   }
  # }

  # Process each data file
  for (rda_file in rda_files) {
    file_name <- basename(rda_file)

    # Skip already processed files
    if (file_name %in% c("anno.Rda", "search_vec.Rda")) {
      next
    }

    message("Processing ", file_name)
    data_type <- tools::file_path_sans_ext(file_name)

    # Load the Rda file in a new environment
    e <- new.env()
    load(rda_file, envir = e)

    # Process each object in the environment
    for (obj_name in ls(e)) {
      obj <- get(obj_name, envir = e)

      # Extract project name from object name
      parts <- strsplit(obj_name, "_")[[1]]
      if (length(parts) < 2) {
        message("  Skipping ", obj_name, " (not in project_datatype format)")
        next
      }

      project_name <- parts[1]
      obj_type <- paste(parts[-1], collapse = "_")  # In case there are underscores in the type

      # Skip if projects is specified and this project is not in the list
      if (!is.null(projects) && !project_name %in% projects) {
        next
      }

      # Table name is project_datatype
      table_name <- paste0(project_name, "_", obj_type)
      message("  - Processing ", table_name)

      if (is.matrix(obj)) {
        # Convert matrix to data frame with feature_id column
        df <- as.data.frame(obj)
        df$feature_id <- rownames(df)

        # Write to database
        DBI::dbWriteTable(con, table_name, df, overwrite = TRUE)

        # Create index on feature_id for faster lookups
        DBI::dbExecute(con, paste0("CREATE INDEX idx_", table_name, "_feature_id ON ",
                                   table_name, " (feature_id)"))
      } else if (is.data.frame(obj)) {
        obj <- as.data.frame(obj)
        # Check if the data frame has rownames and preserve them
        if (!is.null(rownames(obj)) && !all(rownames(obj) == seq_len(nrow(obj)))) {
          # If data frame has meaningful rownames, add them as feature_id column
          df <- obj
          df$feature_id <- rownames(df)

          # Write to database
          DBI::dbWriteTable(con, table_name, df, overwrite = TRUE)

          # Create index on feature_id for faster lookups
          DBI::dbExecute(con, paste0("CREATE INDEX idx_", table_name, "_feature_id ON ",
                                     table_name, " (feature_id)"))
        } else {
          # If no meaningful rownames, write directly
          DBI::dbWriteTable(con, table_name, obj, overwrite = TRUE)
        }
      } else {
        message("    Skipping (unsupported type: ", class(obj)[1], ")")
      }
    }
  }

  # Create a projects table with metadata
  project_names <- unique(sapply(DBI::dbListTables(con), function(t) {
    parts <- strsplit(t, "_")[[1]]
    if (length(parts) >= 2 && !t %in% c("sample_anno", "drug_anno", "search_vectors")) {
      return(parts[1])
    } else {
      return(NA)
    }
  }))
  project_names <- project_names[!is.na(project_names)]

  # Get data types for each project
  project_metadata <- lapply(project_names, function(proj) {
    tables <- grep(paste0("^", proj, "_"), DBI::dbListTables(con), value = TRUE)
    data_types <- unique(sapply(tables, function(t) {
      sub(paste0("^", proj, "_"), "", t)
    }))

    # Try to determine dataset type
    dataset_type <- NA_character_
    if ("sample_anno" %in% DBI::dbListTables(con)) {
      # Get sample IDs for this project
      sample_ids <- DBI::dbGetQuery(con, paste0(
        "SELECT name FROM (",
        paste(lapply(tables, function(t) {
          paste0("SELECT name FROM pragma_table_info('", t, "') ",
                 "WHERE name != 'feature_id'")
        }), collapse = " UNION "),
        ")"
      ))$name

      if (length(sample_ids) > 0) {
        # Look up dataset type in sample_anno
        types_query <- paste0(
          "SELECT DISTINCT DataType FROM sample_anno WHERE SampleID IN ('",
          paste(sample_ids, collapse = "','"),
          "')"
        )
        types <- DBI::dbGetQuery(con, types_query)$DataType

        if (length(types) > 0) {
          dataset_type <- types[1]
        }
      }
    }

    # Count drugs in drug table if available
    drug_count <- 0
    drug_table <- paste0(proj, "_drug")
    if (drug_table %in% DBI::dbListTables(con)) {
      drug_count_query <- paste0("SELECT COUNT(*) FROM ", drug_table)
      drug_count <- DBI::dbGetQuery(con, drug_count_query)[1,1]
    }

    data.frame(
      project_name = proj,
      dataset_type = dataset_type,
      data_types = paste(data_types, collapse = ","),
      sample_count = length(unique(sample_ids)),
      drug_count = drug_count,
      stringsAsFactors = FALSE
    )
  })

  project_table <- do.call(rbind, project_metadata)
  DBI::dbWriteTable(con, "projects", project_table, overwrite = TRUE)

  message("Database creation complete. Database contains ", length(DBI::dbListTables(con)), " tables",
          " for ", length(project_names), " projects.")
  invisible(db_path)
}
