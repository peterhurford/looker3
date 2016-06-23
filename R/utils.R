`%||%` <- function(x, y) if (is.null(x)) y else x

colon_split_to_list <- function(string) {
  colon_split <- strsplit(string, ": ")
  field_names <- lapply(colon_split, `[[`, 1)
  values <- lapply(colon_split, `[[`, 2)
  names(values) <- field_names
  values
}

list_to_colon_split <- function(list) {
  paste(names(list), list, sep = ": ") %>% unlist
}
