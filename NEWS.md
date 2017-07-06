# Version 0.1.15
- Error out if `looker3::looker3` is called with filters that duplicate a dimension name,
  since these will not be processed correctly (JSON objects cannot have duplicate names).

# Version 0.1.14
- Fixed bug where `validate_response` would crash if the response object was not a list.

# Version 0.1.13
- Added a warning if the number of columns returned is different from the number of fields provided.

# Version 0.1.12
- Added message from the http response from Looker to error messages coming from `validate_response`.

# Version 0.1.11
- Fixed bug where `looker3` was not passing `silent_read_csv` to `run_inline_query`.

# Version 0.1.10
- Added a param `silent_csv_read`, to switch off/on warnings while reading the stream into a data frame.

# Version 0.1.9
- Added an extra validation in `extract_query_response` to catch silent errors in the body of httr response objects.

# Version 0.1.8
- Also allow `filters` to be vector.

# Version 0.1.7
- `extract_query_result` now uses `readr::read_csv` instead of `utils::read.csv` under the hood.

# Version 0.1.6
- removed `logout_api_call`, using `cacher` to cache tokens instead.

# Version 0.1.5
- `validate_response` now only warns on unsuccessful logout validations.

# Version 0.1.4
- Error messages on `validate_response` now include step name and status code.

# Version 0.1.3
- Added compatibility for inputs in the format of Looker API 2.0.

# Version 0.1.0
- Added support for `run_inline_query` using the `csv` API endpoint(which supports streaming).

# Version 0.0.1
- Package created.
