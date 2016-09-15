polygonNeighbors <- function(shp, id = NULL, nb.matrix = FALSE, plot = FALSE) {

  if (class(shp) != "SpatialPolygonsDataFrame") {
    stop("'shp' must be a SpatialPolygonsDataFrame.")
  }
  if (class(id) != "character") {
    stop("'id' must be have class character.")
  }
  adj <- spdep::poly2nb(shp)
  adj <- spdep::nb2mat(adj, style = "B", zero.policy = TRUE)

  if (is.null(id)) {
    id <- "row.id"
    shp@data$row.id <- 1:nrow(shp@data)
  }

  if (plot) {
    require(maptools)
    shp.df <- fortify(shp, region = id)
    tmp <- data.frame(id = shp@data[[id]], nb = colSums(adj))
    shp.df <- plyr::join(shp.df, tmp)
    if (length(unique(shp.df$nb)) <= 8) {
      # Labels for number of adjacencies:
      lab.df <- data.frame(coordinates(shp))
      names(lab.df) <- c("long", "lat")
      lab.df$nb <- colSums(adj)
      lab.df$group <- NA
      g <- ggplot(shp.df, aes(long, lat, group = group)) +
        geom_path() +
        geom_polygon(aes(fill = factor(nb))) +
        geom_text(data = lab.df, aes(x = long, y = lat, label = nb),
                  color = "darkgreen") +
        scale_fill_discrete(name = "Number of\nadjacencies") +
        coord_equal() +
        theme(axis.ticks = element_blank(),
              axis.text = element_blank(),
              axis.title = element_blank(),
              panel.background = element_blank())
    } else {
      g <- ggplot(shp.df, aes(long, lat, group = group)) +
        geom_path() +
        geom_polygon(aes(fill = nb)) +
        scale_fill_viridis(name = "Number of\nadjacencies") +
        coord_equal() +
        theme(axis.ticks = element_blank(),
              axis.text = element_blank(),
              axis.title = element_blank(),
              panel.background = element_blank())
    }
  }

  adj <- apply(adj, 2, as.logical)
  rownames(adj) <- shp@data[[id]]
  colnames(adj) <- shp@data[[id]]

  # Convert this to data.frame format (similar to amphoeAdjacency.xlsx"):
  max.adj <- max(rowSums(adj))
  adj.df <- data.frame(id = shp@data[[id]])
  names(adj.df) <- id
  for (i in 1:max.adj) {
    adj.df[[paste0("adj.", i)]] <- NA
    for (j in 1:nrow(adj)) {
      adj.df[[paste0("adj.", i)]][j] <- colnames(adj)[adj[, j]][i]
      adj.df[[paste0("adj.", i)]][j][is.na(adj.df[[paste0("adj.", i)]][j])] <-
        NA
    }
  }
  out <- list()
  out$nb <- adj.df
  if (nb.matrix) {
    out$nb.matrix <- adj
  }
  if (plot) {
    out$plot <- g
  }
  return(out)
}
