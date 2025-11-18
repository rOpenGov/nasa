# Search NASA Earthdata Collections Metadata

Queries NASA's Common Metadata Repository (CMR) to search Earth science
datasets related to a specified keyword. Optionally filters results by a
temporal range.

## Usage

``` r
get_earthdata(keyword, n_results, start_date = NULL, end_date = NULL)
```

## Arguments

- keyword:

  Character. A search term or phrase used to find relevant datasets in
  titles, descriptions, keywords, and provider names.

- n_results:

  Integer. The number of dataset entries to retrieve. If more than 2000,
  multiple pages will be requested automatically.

- start_date:

  Character or NULL. Optional start date filter in "YYYY-MM-DD" format.
  If provided, must be used with `end_date`.

- end_date:

  Character or NULL. Optional end date filter in "YYYY-MM-DD" format. If
  provided, must be used with `start_date`.

## Value

A data frame containing metadata about the matching datasets, with only
cleaned column names (columns with '.' or '\$' removed).

## Details

CMR is the Earthdata search engine, the backend database that stores
metadata about:

\- Satellite datasets - Earth science data (climate, ocean, atmosphere,
land) - Observational granules (single files like images, temperature
readings, etc.) - Services (subsetting, reformatting, and other data
services)

The search finds matches based on the keyword provided. The keyword can
appear in:

\- Dataset titles - Dataset descriptions - Dataset keywords (tags) -
Some provider names

The function accesses the CMR API endpoint:
`https://cmr.earthdata.nasa.gov/` `search/collections.json` (Note: This
is an API endpoint and may return an error when opened in a browser.) It
harmonizes columns across API pages and returns up to the number of
requested results. If no results are found, an empty data frame is
returned.

## Examples

``` r
if (FALSE) { # \dontrun{
# Search for 1 dataset related to sea surface temperature
results <- get_earthdata(keyword = "sea surface temperature", n_results = 1)

# Search with a temporal constraint
results_time <- get_earthdata(
  keyword = "sea surface temperature",
  n_results = 1,
  start_date = "2020-01-01",
  end_date = "2020-01-02"
)
} # }
```
