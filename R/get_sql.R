#' Get underlying sql for a Looker query.
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
#'
#' @return a simple string containing the SQL query.
#'
#' @examples \dontrun{
#'   query <- get_sql(model = "thelook",
#'                 view = "orders",
#'                 fields = c("orders.count", "orders.created_month")
#'                 filters = list("orders.created_month" = "90 days", "orders.status" = "complete")
#'   )
#'
#'   query <- get_sql(model = "thelook",
#'                 view = "orders",
#'                 fields = c("orders.count", "orders.created_month")
#'                 filters = c("orders.created_month: 90 days", "orders.status: complete")
#'   )
#' }
#' @export
get_sql <- checkr::ensure(pre = list(   # model, view, and fields are
             model %is% simple_string,  # required to form a query.
             view %is% simple_string,
             fields %is% character,
             filters %is% simple_string ||
               ((filters %is% list || filters %is% vector) &&
                (filters %contains_only% simple_string || filters %is% empty)),
             limit %is% numeric && limit > 0 && limit %% 1 == 0
           ),

  function(model, view, fields,
            filters = list(), limit = 1000) {

    looker_setup <- setup_using_env_vars()

    # if user-specified filters as a character vector, reformat to a list
    if (!missing(filters) && is.character(filters)) {
      filters <- colon_split_to_list(filters)
    }

    run_inline_query(looker_setup$LOOKER_URL, looker_setup$LOOKER_ID, looker_setup$LOOKER_SECRET,
      model, view, fields, filters, limit, return_format = "sql", silent_read_csv)
  }
)
