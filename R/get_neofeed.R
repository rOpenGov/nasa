#' Retrieve Near-Earth Objects (Asteroids) Within a Date Range
#'
#' Queries NASA's Near Earth Object Web Service (NeoWs) to retrieve data
#' about asteroids and comets approaching Earth within a specified date range.
#'
#' @param start_date Character. The start date for asteroid data in "YYYY-MM-DD" format.
#' @param end_date Character or NULL. The end date in "YYYY-MM-DD" format. If NULL, defaults to 7 days after \code{start_date}.
#' @param api_key Character. NASA API key. Defaults to \code{"DEMO_KEY"}, but a personal API key is recommended.
#'
#' @return A data frame containing information about near-Earth objects, including name, close approach date,
#' relative velocity (km/h), miss distance (kilometers), and estimated diameter (meters).
#'
#' @details
#' The function calls the NeoWs feed endpoint at
#' \url{https://api.nasa.gov/neo/rest/v1/feed}.
#' Each asteroid's metadata is extracted into a tidy format for analysis.
#' The maximum allowed range between start and end dates is 7 days.
#'
#' @examples
#' \dontrun{
#' # Retrieve asteroid data for a 5-day period
#' neo_data <- get_neo_feed(
#'   start_date = "2024-04-01",
#'   end_date = "2024-04-05",
#'   api_key = "DEMO_KEY"
#' )
#' }
#'
#' @export
get_neo_feed <- function(start_date, end_date = NULL, api_key = "DEMO_KEY") {
  # NeoWs: Near Earth Object Web Service

  if (is.null(end_date)) {
    end_date <- as.Date(start_date) + 7
  }

  base_url <- "https://api.nasa.gov/neo/rest/v1/feed"

  res <- httr::GET(base_url, query = list(
    start_date = start_date,
    end_date = end_date,
    api_key = api_key
  ))

  if (httr::status_code(res) != 200) {
    stop("API request failed: ", httr::status_code(res))
  }

  data <- jsonlite::fromJSON(httr::content(res, as = "text", encoding = "UTF-8"))

  if (length(data$near_earth_objects) == 0) {
    stop("No near-Earth objects found for the specified date range.")
  }

  # Flatten all dates into one dataframe
  neo_list <- do.call(rbind, lapply(data$near_earth_objects, function(day) {
    do.call(rbind, lapply(day, function(asteroid) {
      data.frame(
        name = asteroid$name,
        close_approach_date = asteroid$close_approach_data[[1]]$close_approach_date,
        relative_velocity_kph = as.numeric(asteroid$close_approach_data[[1]]$relative_velocity$kilometers_per_hour),
        miss_distance_km = as.numeric(asteroid$close_approach_data[[1]]$miss_distance$kilometers),
        estimated_diameter_min_m = asteroid$estimated_diameter$meters$estimated_diameter_min,
        estimated_diameter_max_m = asteroid$estimated_diameter$meters$estimated_diameter_max,
        is_potentially_hazardous = asteroid$is_potentially_hazardous_asteroid,
        stringsAsFactors = FALSE
      )
    }))
  }))

  return(neo_list)
}
