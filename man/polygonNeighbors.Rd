\name{polygonNeighbors}
\alias{polygonNeighbors}
\title{Find the neighboring regions of each region in a shapefile.}
\description{Find the neighboring regions of each region in a shapefile.
  Outputs a dataframe with each region and optionally a matrix and plot of
  adjacencies.}
\usage{
polygonNeighbors(shp, id = NULL, nb.matrix = FALSE, plot = FALSE)
}
\arguments{
  \item{shp}{A \code{SpatialPolygonsDataFrame}}
  \item{id}{The name of the variable in \code{shp@data} to find adjacencies
    for.}
  \item{nb.matrix}{Whether to output the adjacency matrix as well.}
  \item{plot}{Whether to plot the adjacencies (for checking).}
}
\value{
  Returns a \code{list} with a \code{data.frame} of each adjacency and
  optionally the adjacency matrix and/or a plot of the adjacencies.
}
\examples{
# Get a shapefile of US States:
file <- "http://www2.census.gov/geo/tiger/GENZ2015/shp/cb_2015_us_state_20m.zip"
download.file(file, "states.zip")
unzip("states.zip")
shp <- rgdal::readOGR(".", "cb_2015_us_state_20m")
shp <- shp[!(shp@data$STATEFP \%in\% c("02", "15", "72")),]  # Contiguous US
shp <- sp::spTransform(shp, sp::CRS("+init=epsg:26978"))
state.adj <- polygonNeighbors(shp, id = "NAME", nb.matrix = TRUE, plot = TRUE)
}

