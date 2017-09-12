
# Helper functions ------------------------------------------------------------
copy_repo <- function(github_repo){
  project_name <- strsplit(github_repo, "/")
  project_name <- project_name[[1]][2]
  repo_path <- file.path(rprojroot::find_rstudio_root_file(), "repos", project_name)
  unlink(file.path(repo_path), recursive = TRUE)
  system(paste0("git clone https://github.com/", github_repo, " -b master ", repo_path))
}

copy_article <- function(from, to){
  from <- file.path(rprojroot::find_rstudio_root_file(), "repos", from)
  to <- file.path(rprojroot::find_rstudio_root_file(), to)
  file.copy(from, to, overwrite = TRUE, recursive = TRUE)
}

replace_text <- function(location, lookfor, replacewith){
  location <- file.path(rprojroot::find_rstudio_root_file(), location)
  read_in_file <- readLines(location)
  read_in_file <- gsub(lookfor, replacewith, x = read_in_file, ignore.case = TRUE)
  write(read_in_file, location)
}

remove_lines <- function(location, start, end){
  location <- file.path(rprojroot::find_rstudio_root_file(), location)
  read_in_file <- readLines(location)
  read_in_file <- c(read_in_file[1:(start - 1)], read_in_file[(end + 1) : length(read_in_file)])
  write(read_in_file, location)
}



# End of helper functions -----------------------------------------------------
copy_repo("rstudio/tensorflow.rstudio.com.v2")

file.copy("repos/tensorflow.rstudio.com.v2/themes/rstudio-docs-theme/",
          "themes",
          recursive = TRUE)


# dbplyr repo  ---------------------------------------------------------------
copy_repo("tidyverse/dbplyr")

# dbplyr package article --------------------------------------------------------------
copy_article("dbplyr/vignettes/dbplyr.Rmd", "content/dplyr.Rmd")
replace_text("content/dplyr.Rmd", "Introduction to dbplyr", "Databases using dplyr" )

# dplyr translation article ---------------------------------------------------------
copy_article("dbplyr/vignettes/sql-translation.Rmd", "content/translation.Rmd")
remove_lines("content/translation.Rmd", 247, 248)

# DBI repo  ---------------------------------------------------------------
copy_repo("rstats-db/DBI")

# DBI article -----------------------------------------------------------------
copy_article("DBI/README.md", "content/DBI.Rmd")
remove_lines("content/DBI.Rmd", 3, 13)
replace_text("content/DBI.Rmd", "# DBI", "--- \nTitle: Introduction to DBI \n---" )

# DBI Backend -----------------------------------------------------------------
copy_article("DBI/vignettes/backend.Rmd", "content/backend.Rmd")

# odbc repo  ---------------------------------------------------------------
copy_repo("rstats-db/odbc")

# odbc page -----------------------------------------------
copy_article("odbc/README.md", "content/odbc.Rmd")
remove_lines("content/odbc.Rmd", 9, 186)
replace_text("content/odbc.Rmd", "====", "--- \nTitle: odbc \n---" )
remove_lines("content/odbc.Rmd", 1, 3)
remove_lines("content/odbc.Rmd", 6, 7)

# RMySQL repo  ---------------------------------------------------------------
copy_repo("rstats-db/RMySQL")

# MySQL page -----------------------------------------------
copy_article("RMySQL/README.md", "content/my-sql.Rmd")
replace_text("content/my-sql.Rmd", "======", "--- \nTitle: Database Interface and MySQL Driver for R \n---" )
remove_lines("content/my-sql.Rmd", 8, 14)
### Line 1 may persist after running this script, delete manually

# bigrquery repo  ---------------------------------------------------------------
copy_repo("rstats-db/bigrquery")

# bigrquery page -----------------------------------------------
copy_article("bigrquery/README.md", "content/big-query.Rmd")
replace_text("content/big-query.Rmd", "# bigrquery", "--- \nTitle: Google BigQuery \n---" )
remove_lines("content/big-query.Rmd", 5, 6)

# RSQLite repo  ---------------------------------------------------------------
copy_repo("rstats-db/RSQLite")

# RSQLite page -----------------------------------------------
copy_article("RSQLite/README.md", "content/sqlite.Rmd")
remove_lines("content/sqlite.Rmd", 6, 7)
remove_lines("content/sqlite.Rmd", 1, 3)
replace_text("content/sqlite.Rmd", "=======", "--- \nTitle: RSQLite \n---" )









# If we want spec as the DBI article
#copy_article("DBI/vignettes/spec.Rmd", "/content/DBI.Rmd")
#copy_article("DBI/man", "")
#copy_article("DBI/DESCRIPTION", "DESCRIPTION")

# If we want DBI-1 as the DBI article
#copy_article("DBI/vignettes/DBI-1.Rmd", "/content/DBI.Rmd")
#copy_article("DBI/vignettes/hierarchy.png", "/static/dbi/hierarchy.png")
#copy_article("DBI/vignettes/biblio.bib", "/content/biblio.bib")


