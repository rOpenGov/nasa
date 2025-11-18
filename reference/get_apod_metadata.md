# Retrieve Astronomy Picture of the Day (APOD) images and metadata

Queries NASA's Astronomy Picture of the Day (APOD) API to retrieve
images and metadata between a specified start and end date. Only image
media types are included.

## Usage

``` r
get_apod_metadata(
  start_date,
  end_date,
  api_key = "DEMO_KEY",
  folder_name = NULL
)
```

## Arguments

- start_date:

  Character. Start date for the query in "YYYY-MM-DD" format.

- end_date:

  Character. End date for the query in "YYYY-MM-DD" format.

- api_key:

  Character. NASA API key. Defaults to "DEMO_KEY", but a personal API
  key is recommended.

- folder_name:

  Character or NULL. Folder name to save images on Desktop if provided.
  If NULL, images are only printed and not saved.

## Value

A data frame containing metadata about the APOD images (date, title,
explanation, URL, and media type).

## Details

The function filters out any media types that are not images—for
example, videos. It prints the image along with a truncated explanation
for each entry, then returns the full metadata as a data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve APOD images for a date range
apod_metadata <- get_apod_metadata(
  start_date = "2024-04-01",
  end_date = "2024-04-02",
  api_key = "DEMO_KEY"
)
} # }
```
