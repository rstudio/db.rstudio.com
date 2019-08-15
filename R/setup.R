
remove_html <- function() {
  html_files <- fs::dir_ls("content", glob = "*.html", recurse = TRUE)
  purrr::map(html_files, fs::file_delete)
}

