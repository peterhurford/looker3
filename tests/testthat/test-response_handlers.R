context("response handling helper functions")

fake_login_response   <- list(status = "200",
                            body = list(access_token = "FAKE_TOKEN"))
fake_query_response   <- list(status = "200",
                             body = "ID, VALUE \n 1, 2")
silent_error_response <- list(status = "200",
                              body = "Error: something went wrong despite the status code being successful")
fake_query_failure    <- list(status = "500", error_message = "fake_error_message")
fake_query_failure_without_message <- list(status = "500")

with_mock(
  `httr::status_code` = function(x) x$status,
  `httr::content`     = function(x) list(message = x$error_message), {
  test_that("validate_response errors with step name, status code, and error message", {
    expect_error(validate_response(fake_query_failure),
      "The fake query failure step in looker")
    expect_error(validate_response(fake_query_failure),
      "status code was 500")
    expect_error(validate_response(fake_query_failure),
      "fake_error_message")
  })
  test_that("validate_response yields step name and status code even if there's no message", {
    expect_error(validate_response(fake_query_failure_without_message),
      "The fake query failure without message step in looker")
    expect_error(validate_response(fake_query_failure_without_message),
      "status code was 500")
    expect_error(validate_response(fake_query_failure_without_message),
      "not provided")
  })
  with_mock(`httr::content` = function(x) { x$error_message }, {
    test_that("validate_response yields step name and status code if response content is not a list", {
      expect_error(validate_response(fake_query_failure),
        "The fake query failure step in looker")
      expect_error(validate_response(fake_query_failure),
        "status code was 500")
      expect_error(validate_response(fake_query_failure),
        "fake_error_message")
    })
  })
})

test_that("helpers validate before processing responses", {
  with_mock(
    `looker3:::validate_response` = function(http_object) {
      stop("valiate_response called")
    }, {
      expect_error(extract_login_token(fake_login_response))
      expect_error(extract_query_result(fake_query_response))
  })
})

describe("processing successful responses", {
  with_mock(
  `httr::status_code` = function(response) { response$status },
  `httr::content`     = function(response) { response$body }, {
    test_that("extract_data_from_response returns a data frame", {
      result <- extract_data_from_response(fake_query_response)
      # readr::read_csv adds extra class attributes,
      # so let's remove them before making our comparison
      attributes(result)$spec <- NULL
      class(result) <- "data.frame"
      expect_equal(result, data.frame(ID = as.integer(1),
                                      VALUE = as.integer(2)))
    })
    test_that("extract_data_from_response errors on 'silent' errors", {

      expect_error(extract_data_from_response(silent_error_response),
                   "Error: ")
    })
  })
})

