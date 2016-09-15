# latlong2region
An `R` package to find which regions each region in a shapefile is adjacent to. Outputs a `data.frame` and (optionally) the adjacency matrix and a plot of the adjacencies.

<div align="center">
<img src="https://github.com/walshc/polygonNeighbors/blob/master/example.png?raw=true" width="500">
</div>

## Installation

```r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("walshc/polygonNeighbors")
```

## Example Usage
Download, extract and load a shapefile of US states:
```r
file <- "http://www2.census.gov/geo/tiger/GENZ2015/shp/cb_2015_us_state_20m.zip"
download.file(file, "states.zip")
unzip("states.zip")
shp <- rgdal::readOGR(".", "cb_2015_us_state_20m")
shp <- shp[!(shp@data$STATEFP %in% c("02", "15", "72")),]  # Contiguous US
shp <- sp::spTransform(shp, CRS("+init=epsg:26978"))
```
Use the function (where `"NAME"` is the name of the states in `shp`):
```r
state.adj <- polygonNeighbors(shp, id = "NAME")
```
You can also get the adjacency matrix and/or plot of adjacencies with:
```r
state.adj <- polygonNeighbors(shp, id = "NAME", nb.matrix = TRUE, plot = TRUE)
```

### Output

## Adjacency data.frame
```
> head(state.adj$nb)
        NAME      adj.1     adj.2          adj.3      adj.4          adj.5         adj.6   adj.7 adj.8
1      Texas  Louisiana  Arkansas       Oklahoma New Mexico           <NA>          <NA>    <NA>  <NA>
2 California     Oregon    Nevada        Arizona       <NA>           <NA>          <NA>    <NA>  <NA>
3   Kentucky   Virginia Tennessee           Ohio   Illinois       Missouri West Virginia Indiana  <NA>
4    Georgia  Tennessee   Florida North Carolina    Alabama South Carolina          <NA>    <NA>  <NA>
5  Wisconsin   Michigan Minnesota       Illinois       Iowa           <NA>          <NA>    <NA>  <NA>
6     Oregon California     Idaho     Washington     Nevada           <NA>          <NA>    <NA>  <NA>
```
## Adjacency matrix
```
> state.adj$nb.matrix[1:6, 1:6]
           Texas California Kentucky Georgia Wisconsin Oregon
Texas      FALSE      FALSE    FALSE   FALSE     FALSE  FALSE
California FALSE      FALSE    FALSE   FALSE     FALSE   TRUE
Kentucky   FALSE      FALSE    FALSE   FALSE     FALSE  FALSE
Georgia    FALSE      FALSE    FALSE   FALSE     FALSE  FALSE
Wisconsin  FALSE      FALSE    FALSE   FALSE     FALSE  FALSE
Oregon     FALSE       TRUE    FALSE   FALSE     FALSE  FALSE
```
