# Retrieve Near-Earth Objects (Asteroids) Within a Date Range

Queries NASA's Near Earth Object Web Service (NeoWs) to retrieve data
about asteroids and comets approaching Earth within a specified date
range.

## Usage

``` r
get_neo_feed(start_date, end_date = NULL, api_key = "DEMO_KEY")
```

## Arguments

- start_date:

  Character. The start date for asteroid data in "YYYY-MM-DD" format.

- end_date:

  Character or NULL. The end date in "YYYY-MM-DD" format. If NULL,
  defaults to 7 days after `start_date`.

- api_key:

  Character. NASA API key. Defaults to `"DEMO_KEY"`, but a personal API
  key is recommended.

## Value

A data frame containing information about near-Earth objects, including
name, close approach date, relative velocity (km/h), miss distance
(kilometers), and estimated diameter (meters).

## Details

The function calls the NeoWs feed endpoint at
<https://api.nasa.gov/neo/rest/v1/feed>. Each asteroid's metadata is
extracted into a tidy format for analysis. The maximum allowed range
between start and end dates is 7 days.

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve asteroid data for a 5-day period
neo_data <- get_neo_feed(
  start_date = "2024-04-01",
  end_date = "2024-04-05",
  api_key = "DEMO_KEY"
)
} # }
```
