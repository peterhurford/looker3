## looker3
[![Build status](https://circleci.int.avant.com/gh/avantcredit/looker3.svg?style=shield&circle-token=cba511bcfb3de5d2b73d9770e9f7e4c359d9b5dd)](https://circleci.int.avant.com/gh/avantcredit/looker3)
<a href="https://codecov.io/github/avantcredit/looker3"><img
src="https://img.shields.io/codecov/c/github/avantcredit/looker3.svg"></a>
<a href="https://github.com/avantcredit/looker3/tags"><img src="https://img.shields.io/github/tag/avantcredit/looker3.svg"></a>

Pull data from Looker with the 3.0 API.

## Installation

```R
if (!require("devtools")) { install.packages("devtools") }
devtools::install_github("avantcredit/looker3")
```

## How it works

Before pulling data from Looker, you need to set up environment variables LOOKER_URL, LOOKER_ID, and LOOKER_SECRET with the url to your Looker instance, your client id, and your client secret respectively.

Once those are set up, you can access data using the `looker3` function:
```R
library("looker3")
df <- looker3(model = "thelook",
              view = "orders",
              fields = c("orders.count", "orders.created_month")
              filters = list("orders.created_month" = "90 days", "orders.status" = "complete")
)
```

# Specifying filters

There are two ways to specify filters. 
* As a list, as illustrated above
* As a vector, using a colon as a separator, e.g.

```
filters = c("orders.created_month: 90 days", "orders.status: complete")
```

