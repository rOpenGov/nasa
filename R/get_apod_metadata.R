# Declare global variables to satisfy R CMD check
utils::globalVariables(c("media_type", "title", "explanation"))

#' Retrieve Astronomy Picture of the Day (APOD) images and metadata
#'
#' Queries NASA's Astronomy Picture of the Day (APOD) API to retrieve images and metadata
#' between a specified start and end date. Only image media types are included.
#'
#' @param start_date Character. Start date for the query in "YYYY-MM-DD" format.
#' @param end_date Character. End date for the query in "YYYY-MM-DD" format.
#' @param api_key Character. NASA API key. Defaults to "DEMO_KEY", but a personal API key is recommended.
#' @param folder_name Character or NULL. Folder name to save images on Desktop if provided. If NULL, images are only printed and not saved.
#'
#' @return A data frame containing metadata about the APOD images (date, title, explanation, URL, and media type).
#'
#' @details The function filters out any media types that are not images (e.g., videos).
#' It prints the image along with a truncated explanation for each entry,
#' then returns the full metadata as a data frame.
#'
#' @examples
#' \dontrun{
#' # Retrieve APOD images for a date range
#' apod_metadata <- get_apod_metadata(
#'   start_date = "2024-04-01",
#'   end_date = "2024-04-02",
#'   api_key = "DEMO_KEY"
#' )
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr filter select
#' @importFrom magick image_read image_write
#' @export
get_apod_metadata <- function(start_date, end_date, api_key = "DEMO_KEY", folder_name = NULL) {
  # Astronomy Picture of the Day

  base_url <- "https://api.nasa.gov/planetary/apod"

  # API Request
  res <- GET(base_url, query = list(
    start_date = start_date,
    end_date = end_date,
    api_key = api_key
  ))

  if (status_code(res) != 200) {
    stop("API request failed: ", status_code(res))
  }

  data <- fromJSON(content(res, as = "text", encoding = "UTF-8"))
  df <- as.data.frame(data) %>%
    filter(media_type == "image") %>%  # Only images
    select(date, title, explanation, url, media_type)

  if (nrow(df) == 0) {
    stop("No images found in the selected date range!")
  }

  # Handle Desktop saving if folder name is provided
  if (!is.null(folder_name)) {
    desktop_path <- file.path(path.expand("~/Desktop"), folder_name)

    if (!dir.exists(desktop_path)) {
      dir.create(desktop_path, recursive = TRUE)
    }
  }

  # Loop over images: display and optionally save
  for (i in 1:nrow(df)) {
    cat("\n", "Date: ", df$date[i], "\n", "Title: ", df$title[i], "\n", sep = "")
    cat("Explanation: ", substr(df$explanation[i], 1, 300), "...\n\n")  # Print first 300 chars

    img <- image_read(df$url[i])
    print(img)

    if (!is.null(folder_name)) {
      # Build a filename
      filename <- paste0("APOD_", df$date[i], ".jpg")
      file_path <- file.path(desktop_path, filename)
      image_write(img, path = file_path, format = "jpg")
      cat("Saved to:", file_path, "\n")
    }

    Sys.sleep(2)  # Pause to view
  }

  # Return the full metadata dataframe at the end
  return(df)
}
