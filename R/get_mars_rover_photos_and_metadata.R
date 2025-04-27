# Declare global variables to satisfy R CMD check
utils::globalVariables(c("id", "sol", "camera.full_name", "img_src", "rover.name"))

#' Retrieve and Save Mars Rover Photos
#'
#' Queries NASA's Mars Rover Photos API to retrieve photos taken by a specified rover on a given Earth date.
#' Optionally saves the images to a folder on the user's Desktop.
#'
#' @param rover Character. The name of the Mars rover. Must be one of: \code{"curiosity"}, \code{"opportunity"}, \code{"spirit"}, or \code{"perseverance"}. Default is \code{"curiosity"}.
#' @param earth_date Character. The Earth date to query in "YYYY-MM-DD" format. Default is \code{"2024-04-01"}.
#' @param api_key Character. NASA API key. Defaults to \code{"DEMO_KEY"}, but a personal API key is recommended.
#' @param folder_name Character or NULL. If provided, images will be saved in a folder with this name on the user's Desktop. If NULL, images are only displayed and not saved.
#'
#' @return A data frame containing metadata about the retrieved photos, including photo ID, sol (Martian day), camera name, image source URL, Earth date, and rover name.
#'
#' @details The function prints each retrieved image and associated metadata to the console.
#' If a folder name is specified, images are saved to the Desktop inside the given folder.
#' Only images taken on the specified date are returned; if no images exist, the function stops with an error.
#'
#' @examples
#' \dontrun{
#' # Retrieve and save photos taken by Curiosity on June 3, 2015
#' mars_photos_metadata <- get_mars_rover_photos_and_metadata(
#'   rover = "curiosity",
#'   earth_date = "2015-06-03",
#'   api_key = "DEMO_KEY",
#'   folder_name = "MarsPhotos"
#' )
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom magick image_read image_write
#' @importFrom dplyr select
#' @importFrom dplyr %>%
#' @export
get_mars_rover_photos_and_metadata <- function(rover, earth_date,
                                               api_key = "DEMO_KEY", folder_name = NULL) {

  valid_rovers <- c("curiosity", "opportunity", "spirit", "perseverance")

  if (!(rover %in% valid_rovers)) {
    stop("Invalid rover name. Please select from: 'curiosity', 'opportunity', 'spirit', or 'perseverance'.")
  }

  base_url <- paste0("https://api.nasa.gov/mars-photos/api/v1/rovers/", rover, "/photos")

  # Make API call
  res <- GET(base_url, query = list(
    earth_date = earth_date,
    api_key = api_key
  ))

  if (status_code(res) != 200) {
    stop("API request failed: ", status_code(res))
  }

  data <- fromJSON(content(res, as = "text", encoding = "UTF-8"), flatten = TRUE)

  if (length(data$photos) == 0) {
    stop("No photos found for this date and rover!")
  }

  df <- as.data.frame(data$photos) %>%
    select(id, sol, camera.full_name, img_src, earth_date, rover.name)

  # Handle Desktop saving
  if (!is.null(folder_name)) {
    desktop_path <- file.path(path.expand("~/Desktop"), folder_name)

    if (!dir.exists(desktop_path)) {
      dir.create(desktop_path, recursive = TRUE)
    }
  }

  # Loop through photos
  for (i in 1:nrow(df)) {
    cat("\n", "Earth Date: ", df$earth_date[i], "\n", "Rover: ", df$rover.name[i], "\n",
        "Camera: ", df$camera.full_name[i], "\n", sep = "")

    img <- image_read(df$img_src[i])
    print(img)

    if (!is.null(folder_name)) {
      # Build a filename
      filename <- paste0(df$rover.name[i], "_", df$earth_date[i], "_photo", df$id[i], ".jpg")
      file_path <- file.path(desktop_path, filename)
      image_write(img, path = file_path, format = "jpg")
      cat("Saved to:", file_path, "\n")
    }

    Sys.sleep(2)  # Pause between photos
  }

  # Return the metadata
  return(df)
}
