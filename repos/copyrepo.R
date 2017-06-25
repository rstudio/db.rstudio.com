
# Helper function: copies an entire repo to a folder inside 'repo' ------------
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
  read_in_file <- c(read_in_file[1:start - 1], read_in_file[end + 1 : length(read_in_file)])
  write(read_in_file, location)
}



# End of helper functions -----------------------------------------------------


# dbplyr article --------------------------------------------------------------
copy_repo("tidyverse/dbplyr")
copy_article("dbplyr/vignettes/dbplyr.Rmd", "content/dplyr.Rmd")
replace_text("content/dplyr.Rmd", "Introduction to dbplyr", "Databases using dplyr" )

# DBI article -----------------------------------------------------------------
copy_repo("rstats-db/DBI")
copy_article("DBI/README.md", "content/DBI.md")
replace_text("content/DBI.md", "# DBI", "# Introduction to DBI" )
remove_lines("content/DBI.md", 3, 8)


# If we want spec as the DBI article
#copy_article("DBI/vignettes/spec.Rmd", "/content/DBI.Rmd")
#copy_article("DBI/man", "")
#copy_article("DBI/DESCRIPTION", "DESCRIPTION")

# If we want DBI-1 as the DBI article
#copy_article("DBI/vignettes/DBI-1.Rmd", "/content/DBI.Rmd")
#copy_article("DBI/vignettes/hierarchy.png", "/static/dbi/hierarchy.png")
#copy_article("DBI/vignettes/biblio.bib", "/content/biblio.bib")


