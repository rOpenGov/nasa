#' Retrieve Near-Earth Objects (Asteroids) Within a Date Range
#'
#' Queries NASA's Near Earth Object Web Service (NeoWs) to retrieve data
#' about asteroids and comets approaching Earth within a specified date range.
#'
#' @param start_date Character. The start date for asteroid data in \code{"YYYY-MM-DD"} format.
#' @param end_date Character or NULL. The end date in \code{"YYYY-MM-DD"} format. If NULL, defaults to 7 days after \code{start_date}.
#' @param api_key Character. NASA API key. Defaults to \code{"DEMO_KEY"}, but a personal API key is recommended.
#'
#' @return A data frame containing information about near-Earth objects, including:
#' - Name
#' - Close approach date
#' - Relative velocity (km/h)
#' - Miss distance (kilometers)
#' - Estimated diameter (meters)
#'
#' @details
#' The function calls NASA's Near Earth Object Web Service (NeoWs).
#' The feed endpoint used is:
#' \code{https://api.nasa.gov/neo/rest/v1/feed}
#'
#' Note: This endpoint may return a 403 Forbidden error when accessed during automated checks (e.g., \code{R CMD check}).
#'
#' @note
#' During CRAN checks, the API endpoint may return a 403 Forbidden error. This does not affect normal package functionality when used interactively with a valid API key.
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
