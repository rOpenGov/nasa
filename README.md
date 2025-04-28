# nasa

[![](https://cranlogs.r-pkg.org/badges/nasa)](https://cran.r-project.org/package=nasa)
[![](https://cranlogs.r-pkg.org/badges/grand-total/nasa)](https://cran.r-project.org/package=nasa)
[![](https://www.r-pkg.org/badges/version/nasa)](https://CRAN.R-project.org/package=nasa)

Access National Aeronautics and Space Administration (NASA) Open APIs for Space and Earth Data.

The nasa package provides functions to access and download data from various NASA APIs, including:
- Astronomy Picture of the Day (APOD): https://api.nasa.gov/planetary/apod
- Mars Rover Photos: https://api.nasa.gov/mars-photos/api/v1/rovers
- Earth Polychromatic Imaging Camera (EPIC): https://api.nasa.gov/EPIC/api/natural
- Near Earth Object Web Service (NeoWs): https://api.nasa.gov/neo/rest/v1/neo/browse
- Earth Observatory Natural Event Tracker (EONET): https://eonet.gsfc.nasa.gov/api/v3/events
- NASA Earthdata Common Metadata Repository (CMR): https://cmr.earthdata.nasa.gov/search/collections.json

All retrieved data is returned in cleaned, tidy data frames suitable for analysis or visualization.

### API Use

Most functions in this package can be run using the default `DEMO_KEY`. However, because the DEMO_KEY is publicly shared and subject to rate limits, it is strongly recommended to request your own API key from NASA. You can quickly obtain a personal key by visiting [https://api.nasa.gov/](https://api.nasa.gov/).

### Installation

Currently, install from local files or GitHub (future release):

### Install devtools if needed
`install.packages("devtools")`

### Install from GitHub (after uploading)
`devtools::install_github("yourusername/nasa")`

### Functions

`get_apod_metadata(start_date, end_date, api_key = "DEMO_KEY", folder_name = NULL)`
- Queries APOD to retrieve image metadata between two dates.
- Only returns results where the media type is an image.
- Optionally saves images to a folder on the Desktop.

`get_mars_rover_photos_and_metadata(rover, earth_date, api_key = "DEMO_KEY", folder_name = NULL)`
- Retrieves photos taken by a Mars rover on a specific Earth date.
- Valid rover names: "curiosity", "opportunity", "spirit", "perseverance".
- Optionally saves photos to a folder on the Desktop.

`get_earthdata(keyword, n_results, start_date = NULL, end_date = NULL)`
- Searches the NASA Earthdata CMR database for datasets matching a keyword.
- Can optionally filter results by a temporal range.
- Returns a cleaned data frame of dataset metadata.

### Example usage

#### Load the library
`library(nasa)`

#### Get Astronomy Picture of the Day metadata
```
apod_data <- get_apod_metadata(
  start_date = "2024-04-01",
  end_date = "2024-04-02",
  api_key = "DEMO_KEY")
```

#### Retrieve Mars Rover Photos metadata
```
mars_data <- get_mars_rover_photos_and_metadata(
  rover = "curiosity",
  earth_date = "2020-02-01",
  api_key = "DEMO_KEY")
```

#### Search Earthdata for "sea surface temperature" (or any keyword or phrase)
```
earthdata_results <- get_earthdata(
  keyword = "sea surface temperature",
  n_results = 10)
```

