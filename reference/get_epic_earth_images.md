# Retrieve and Save EPIC Natural Color Earth Images

Queries NASA's EPIC (Earth Polychromatic Imaging Camera) API to retrieve
metadata and images of Earth taken on a specified date. Images can
optionally be saved to a folder on the user's Desktop.

## Usage

``` r
get_epic_earth_images(date = NULL, api_key = "DEMO_KEY", folder_name = NULL)
```

## Arguments

- date:

  Character or NULL. The Earth date in "YYYY-MM-DD" format to retrieve
  images from. If NULL, today's date is used. Note that today's images
  may not yet be available.

- api_key:

  Character. NASA API key. Defaults to `"DEMO_KEY"`, but a personal API
  key is recommended.

- folder_name:

  Character or NULL. If provided, images will be saved in a folder with
  this name on the user's Desktop. If NULL, images are only displayed
  and not saved.

## Value

A data frame containing metadata for the retrieved EPIC images,
including image names, dates, and captions.

## Details

The function builds the download URLs based on NASA's EPIC archive
structure, which organizes images into year/month/day subfolders. Only
natural color images are retrieved. Images are displayed using the
`magick` package and can be optionally saved as PNG files.

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve and view EPIC images from April 1, 2024
epic_data <- get_epic_earth_images(date = "2024-04-01", api_key = "your_actual_api_key")

# Retrieve and save EPIC images to Desktop/EPIC_Images
epic_data_saved <- get_epic_earth_images(
  date = "2024-04-01",
  api_key = "DEMO_KEY",
  folder_name = "EPIC_Images"
)
} # }
```
