% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_earthdata.R
\name{get_earthdata}
\alias{get_earthdata}
\title{Search NASA Earthdata Collections Metadata}
\usage{
get_earthdata(keyword, n_results, start_date = NULL, end_date = NULL)
}
\arguments{
\item{keyword}{Character. A search term or phrase used to find relevant datasets
in titles, descriptions, keywords, and provider names.}

\item{n_results}{Integer. The number of dataset entries to retrieve.
If more than 2000, multiple pages will be requested automatically.}

\item{start_date}{Character or NULL. Optional start date filter in "YYYY-MM-DD" format.
If provided, must be used with \code{end_date}.}

\item{end_date}{Character or NULL. Optional end date filter in "YYYY-MM-DD" format.
If provided, must be used with \code{start_date}.}
}
\value{
A data frame containing metadata about the matching datasets,
with only cleaned column names (columns with '.' or '$' removed).
}
\description{
Queries NASA's Common Metadata Repository (CMR) to search Earth science datasets
related to a specified keyword. Optionally filters results by a temporal range.
}
\details{
CMR is the Earthdata search engine, the backend database that stores metadata about:

- Satellite datasets
- Earth science data (climate, ocean, atmosphere, land)
- Observational granules (single files like images, temperature readings, etc.)
- Services (subsetting, reformatting, and other data services)

The search finds matches based on the keyword provided. The keyword can appear in:

- Dataset titles
- Dataset descriptions
- Dataset keywords (tags)
- Some provider names

The function accesses the CMR API endpoint:
\code{https://cmr.earthdata.nasa.gov/}
\code{search/collections.json}
(Note: This is an API endpoint and may return an error when opened in a browser.)
It harmonizes columns across API pages and returns up to the number of requested results.
If no results are found, an empty data frame is returned.
}
\examples{
\dontrun{
# Search for 1 dataset related to sea surface temperature
results <- get_earthdata(keyword = "sea surface temperature", n_results = 1)

# Search with a temporal constraint
results_time <- get_earthdata(
  keyword = "sea surface temperature",
  n_results = 1,
  start_date = "2020-01-01",
  end_date = "2020-01-02"
)
}

}
