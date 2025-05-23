% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_mars_rover_photos_and_metadata.R
\name{get_mars_rover_photos_and_metadata}
\alias{get_mars_rover_photos_and_metadata}
\title{Retrieve and Save Mars Rover Photos}
\usage{
get_mars_rover_photos_and_metadata(
  rover,
  earth_date,
  api_key = "DEMO_KEY",
  folder_name = NULL
)
}
\arguments{
\item{rover}{Character. The name of the Mars rover.
Must be one of the following:
\itemize{
  \item \code{"curiosity"}
  \item \code{"opportunity"}
  \item \code{"spirit"}
  \item \code{"perseverance"}
}}

\item{earth_date}{Character. The Earth date to query in \code{"YYYY-MM-DD"} format. Default is \code{"2024-04-01"}.}

\item{api_key}{Character. NASA API key. Defaults to \code{"DEMO_KEY"}, but a personal API key is recommended.}

\item{folder_name}{Character or NULL. If provided, images will be saved in a folder with this name on the user's Desktop.
If NULL, images are only displayed and not saved.}
}
\value{
A data frame containing metadata about the retrieved photos, including photo ID, sol (Martian day),
camera name, image source URL, Earth date, and rover name.
}
\description{
Queries NASA's Mars Rover Photos API to retrieve photos taken by a specified rover on a given Earth date.
Optionally saves the images to a folder on the user's Desktop.
}
\details{
The function prints each retrieved image and associated metadata to the console.
If a folder name is specified, images are saved to the Desktop inside the given folder.
Only images taken on the specified date are returned; if no images exist, the function stops with an error.
}
\examples{
\dontrun{
# Retrieve and save photos taken by Curiosity on June 3, 2015
mars_photos_metadata <- get_mars_rover_photos_and_metadata(
  rover = "curiosity",
  earth_date = "2015-06-03",
  api_key = "DEMO_KEY",
  folder_name = "MarsPhotos"
)
}

}
