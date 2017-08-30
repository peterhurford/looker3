cached_token_is_invalid <- function() {
  if (!token_cache$exists("token")) { return(TRUE) }
  expiration_date <- token_cache$get("token")$expires_in
  is.null(expiration_date) || methods::is(expiration_date, "POSIXt") || i
    (expiration_date < Sys.time())
}

is.successful_response <- function(response) {
  httr::status_code(response) %in% c("200", "201", "202", "204")
}

extract_error_message <- function(response) {
  response_body <- httr::content(response)
  if (is.list(response_body)) {
    response_body$message
  } else {
    response_body
  }
}

validate_response <- function(response) {
  if (is.successful_response(response)) { return(TRUE) }

  stop(paste("The",
    gsub("_", " ", deparse(substitute(response))),
    "step in looker failed. The status code was",
    httr::status_code(response),
    "and the error message was",
    extract_error_message(response) %||% "not provided."
    )
  )
}

put_new_token_in_cache <- function(login_response) {
  validate_response(login_response)
  token_cache$set("token", list(
    token      = httr::content(login_response)$access_token,
    # avoid token expiration during code execution
    expires_in = Sys.time() + httr::content(login_response)$expires_in - 1 
  ))
}

extract_query_result <- function(query_response, return_format, silent_read_csv = TRUE) {
  validate_response(query_response)
  data_from_query <- httr::content(query_response)
  if (grepl("^Error:", data_from_query)) {
    # assume that the query errored quietly and that data_from_query is an error message.
    stop("Looker returned no data and the following error message:\n", as.character(data_from_query))
  }
  if (identical(return_format, "csv") && silent_read_csv) {
    suppressWarnings(readr::read_csv(data_from_query))
  } else {
    readr::read_csv(data_from_query)
  }
}

