#' Retrieve and Save EPIC Natural Color Earth Images
#'
#' Queries NASA's EPIC (Earth Polychromatic Imaging Camera) API to retrieve metadata
#' and images of Earth taken on a specified date. Images can optionally be saved to a folder on the user's Desktop.
#'
#' @param date Character or NULL. The Earth date in "YYYY-MM-DD" format to retrieve images from.
#' If NULL, today's date is used. Note that today's images may not yet be available.
#' @param api_key Character. NASA API key. Defaults to \code{"DEMO_KEY"}, but a personal API key is recommended.
#' @param folder_name Character or NULL. If provided, images will be saved in a folder with this name on the user's Desktop.
#' If NULL, images are only displayed and not saved.
#'
#' @return A data frame containing metadata for the retrieved EPIC images, including image names, dates, and captions.
#'
#' @details
#' The function builds the download URLs based on NASA's EPIC archive structure, which organizes images into
#' year/month/day subfolders. Only natural color images are retrieved.
#' Images are displayed using the \code{magick} package and can be optionally saved as PNG files.
#'
#' @examples
#' \dontrun{
#' # Retrieve and view EPIC images from April 1, 2024
#' epic_data <- get_epic_earth_images(date = "2024-04-01", api_key = "your_actual_api_key")
#'
#' # Retrieve and save EPIC images to Desktop/EPIC_Images
#' epic_data_saved <- get_epic_earth_images(
#'   date = "2024-04-01",
#'   api_key = "DEMO_KEY",
#'   folder_name = "EPIC_Images"
#' )
#' }
#'
#' @export
get_epic_earth_images <- function(date = NULL, api_key = "DEMO_KEY", folder_name = NULL) {
  # Retrieve EPIC natural color images from NASA API

  # If no date is provided, use today's date (but images may not be available immediately)
  if (is.null(date)) {
    date <- Sys.Date()
  } else {
    date <- as.Date(date)
  }

  base_url <- "https://api.nasa.gov/EPIC/api/natural/date"
  request_url <- paste0(base_url, "/", date)

  res <- httr::GET(request_url, query = list(api_key = api_key))

  if (httr::status_code(res) != 200) {
    stop("API request failed: ", httr::status_code(res))
  }

  data <- jsonlite::fromJSON(httr::content(res, as = "text", encoding = "UTF-8"))

  if (length(data) == 0) {
    stop("No EPIC images found for this date.")
  }

  # Build base URL for images
  image_base_url <- "https://epic.gsfc.nasa.gov/archive/natural"

  # Handle Desktop saving if folder name is provided
  if (!is.null(folder_name)) {
    desktop_path <- file.path(path.expand("~/Desktop"), folder_name)
    if (!dir.exists(desktop_path)) {
      dir.create(desktop_path, recursive = TRUE)
    }
  }

  # Loop through images
  for (i in 1:nrow(data)) {
    image_name <- data$image[i]
    image_date <- as.Date(data$date[i])

    # EPIC archive URL format requires YYYY/MM/DD folder structure
    year <- format(image_date, "%Y")
    month <- format(image_date, "%m")
    day <- format(image_date, "%d")

    full_image_url <- paste0(
      "https://epic.gsfc.nasa.gov/archive/natural/",
      year, "/", month, "/", day, "/png/", image_name, ".png"
    )

    message("\n", "Image Date-Time: ", data$date[i], "\n", "Caption: ", data$caption[i], "\n", sep = "")

    img <- magick::image_read(full_image_url)
    #print(img)

    if (!is.null(folder_name)) {
      filename <- paste0("EPIC_", image_name, ".png")
      file_path <- file.path(desktop_path, filename)
      magick::image_write(img, path = file_path, format = "png")
      message("Saved to:", file_path, "\n")
    }

    Sys.sleep(1)  # Optional pause to view images
  }

  # Return the full metadata
  return(data)
}
