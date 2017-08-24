#' Pull data from Looker.
#'
#' This function assumes that you have set the environment
#' variables \code{LOOKER_URL}, \code{LOOKER_ID}, and 
#' \code{LOOKER_SECRET}.
#'
#' The function will not allow the query to proceed unless you specify
#' a model, a view, and at least one field.
#'
#' @param model character. The \code{model} parameter of the query.
#' @param view character. The \code{view} parameter of the query.
#' @param fields character. The \code{fields} parameter of the query.
#' @param filters list or character.  Either a named list, or a character
#' vector using colons as separators
#' each vector describing one of the \code{filters} of the query.
#' @param limit numeric. The \code{limit} parameter of the query.
#' @param silent_read_csv logical. Whether or not to suppress warnings
#' when reading the streamed data into a data frame.
#'
#' @return a data.frame containing the data returned by the query
#'
#' @examples \dontrun{
#'   df <- looker3(model = "thelook",
#'                 view = "orders",
#'                 fields = c("orders.count", "orders.created_month")
#'                 filters = list("orders.created_month" = "90 days", "orders.status" = "complete")
#'   )
#' 
#'   df <- looker3(model = "thelook",
#'                 view = "orders",
#'                 fields = c("orders.count", "orders.created_month")
#'                 filters = c("orders.created_month: 90 days", "orders.status: complete")
#'   )  
#' }
#' @export
looker3 <- checkr::ensure(pre = list(   # model, view, and fields are
             model %is% simple_string,  # required to form a query.
             view %is% simple_string,
             fields %is% character,
             filters %is% simple_string ||
               ((filters %is% list || filters %is% vector) &&
                (filters %contains_only% simple_string || filters %is% empty)),
             limit %is% numeric && limit > 0 && limit %% 1 == 0,
             silent_read_csv %is% logical
           ), 

  function(model, view, fields,
            filters = list(), limit = 1000,
            silent_read_csv = TRUE) {

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

    # if user-specified filters as a character vector, reformat to a list
    if (!missing(filters) && is.character(filters)) {
      filters <- colon_split_to_list(filters) 
      # Take duplicate filters which will have multiple occurences of the same key
      # name in the filters list and flatten them into character vectors so each
      # key is unique.
      filters <- tapply(filters, names(filters), FUN = function(queries) { unlist(unname(queries)) })
      if (anyDuplicated(names(filters))) {
        stop("Looker query contains duplicate filters and only the first one ",
             "will be executed. Please drop or coalesce these: ",
             paste(unique(names(filters)[duplicated(names(filters))]), collapse = ", "),
             call. = FALSE)
      }
    }


    run_inline_query(looker_setup$LOOKER_URL, looker_setup$LOOKER_ID, looker_setup$LOOKER_SECRET,
      model, view, fields, filters, limit, silent_read_csv)
  }
)

