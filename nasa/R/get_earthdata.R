# Needed for base functions not automatically found
utils::globalVariables(c("head"))

#' Search NASA Earthdata Collections Metadata
#'
#' Queries NASA's Common Metadata Repository (CMR) to search Earth science datasets
#' related to a specified keyword. Optionally filters results by a temporal range.
#'
#' @details
#' CMR is the Earthdata search engine, the backend database that stores metadata about:
#'
#' - Satellite datasets
#' - Earth science data (climate, ocean, atmosphere, land)
#' - Observational granules (single files like images, temperature readings, etc.)
#' - Services (subsetting, reformatting, and other data services)
#'
#' The search finds matches based on the keyword provided. The keyword can appear in:
#'
#' - Dataset titles
#' - Dataset descriptions
#' - Dataset keywords (tags)
#' - Some provider names
#'
#' The function accesses the CMR API endpoint:
#' \code{https://cmr.earthdata.nasa.gov/}
#' \code{search/collections.json}
#' (Note: This is an API endpoint and may return an error when opened in a browser.)
#' It harmonizes columns across API pages and returns up to the number of requested results.
#' If no results are found, an empty data frame is returned.
#'
#' @param keyword Character. A search term or phrase used to find relevant datasets
#' in titles, descriptions, keywords, and provider names.
#' @param n_results Integer. The number of dataset entries to retrieve.
#' If more than 2000, multiple pages will be requested automatically.
#' @param start_date Character or NULL. Optional start date filter in "YYYY-MM-DD" format.
#' If provided, must be used with \code{end_date}.
#' @param end_date Character or NULL. Optional end date filter in "YYYY-MM-DD" format.
#' If provided, must be used with \code{start_date}.
#'
#' @return A data frame containing metadata about the matching datasets,
#' with only cleaned column names (columns with '.' or '$' removed).
#'
#' @examples
#' \dontrun{
#' # Search for 1 dataset related to sea surface temperature
#' results <- get_earthdata(keyword = "sea surface temperature", n_results = 1)
#'
#' # Search with a temporal constraint
#' results_time <- get_earthdata(
#'   keyword = "sea surface temperature",
#'   n_results = 1,
#'   start_date = "2020-01-01",
#'   end_date = "2020-01-02"
#' )
#' }
#'
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @export
get_earthdata <- function(keyword, n_results, start_date = NULL, end_date = NULL) {

  page_size <- 2000  # maximum allowed by API
  pages_needed <- ceiling(n_results / page_size)

  all_entries <- list()

  for (page_num in 1:pages_needed) {
    query <- list(
      keyword = keyword,
      page_size = page_size,
      page_num = page_num
    )

    # Add temporal parameters if provided
    if (!is.null(start_date) && !is.null(end_date)) {
      query$temporal <- paste0(start_date, ",", end_date)
    }

    res <- GET("https://cmr.earthdata.nasa.gov/search/collections.json", query = query)

    data <- fromJSON(content(res, as = "text", encoding = "UTF-8"), flatten = TRUE)

    if (!is.null(data$feed$entry)) {
      entries <- as.data.frame(data$feed$entry, stringsAsFactors = FALSE)
      all_entries[[length(all_entries) + 1]] <- entries
    } else {
      break  # no more data
    }
  }

  if (length(all_entries) == 0) {
    return(data.frame())  # return empty dataframe if no results
  }

  # Harmonize columns across all pages
  all_colnames <- unique(unlist(lapply(all_entries, names)))

  all_entries_aligned <- lapply(all_entries, function(df) {
    missing_cols <- setdiff(all_colnames, names(df))
    for (col in missing_cols) {
      df[[col]] <- NA
    }
    df <- df[, all_colnames]
    return(df)
  })

  # Now combine safely
  df <- do.call(rbind, all_entries_aligned)

  # Keep only columns without '.' or '$' in their names
  df_clean <- df[
    , !grepl("\\.|\\$", names(df))
  ]

  # Return only requested number of results
  return(head(df_clean, n_results))
}

