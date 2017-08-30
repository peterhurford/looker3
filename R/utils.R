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

setup_using_env_vars <- function() {
  env_var_descriptions <- list(
    LOOKER_URL    = "API url",
    LOOKER_ID     = "client id",
    LOOKER_SECRET = "client secret"
  )

  looker_setup <- lapply(names(env_var_descriptions), function(name) {
    env_var <- Sys.getenv(name)
    if (env_var == "") {
      stop(paste0("Your environment variables are not set correctly. ",
        "please place your Looker 3.0 ", env_var_descriptions[[name]],
        " in the environment variable ", name, "."
      ))
    }
    env_var
  })

  names(looker_setup) <- names(env_var_descriptions)
  looker_setup
}
