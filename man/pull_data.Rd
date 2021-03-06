% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pull_data.R
\name{pull_data}
\alias{pull_data}
\title{Pull data from Looker.}
\usage{
pull_data(model, view, fields, filters = list(), limit = 1000,
  silent_read_csv = TRUE)
}
\arguments{
\item{model}{character. The \code{model} parameter of the query.}

\item{view}{character. The \code{view} parameter of the query.}

\item{fields}{character. The \code{fields} parameter of the query.}

\item{filters}{list or character.  Either a named list, or a character
vector using colons as separators
each vector describing one of the \code{filters} of the query.}

\item{limit}{numeric. The \code{limit} parameter of the query.}

\item{silent_read_csv}{logical. Whether or not to suppress warnings
when reading the streamed data into a data frame.}
}
\value{
a data.frame containing the data returned by the query
}
\description{
This function assumes that you have set the environment
variables \code{LOOKER_URL}, \code{LOOKER_ID}, and
\code{LOOKER_SECRET}.
}
\details{
The function will not allow the query to proceed unless you specify
a model, a view, and at least one field.
}
\examples{
\dontrun{
  df <- pull_data(model = "thelook",
                view = "orders",
                fields = c("orders.count", "orders.created_month")
                filters = list("orders.created_month" = "90 days", "orders.status" = "complete")
  )

  df <- pull_data(model = "thelook",
                view = "orders",
                fields = c("orders.count", "orders.created_month")
                filters = c("orders.created_month: 90 days", "orders.status: complete")
  )
}
}

