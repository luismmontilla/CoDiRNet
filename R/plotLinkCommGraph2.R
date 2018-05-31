# --- 
# title: "plotLinkCommGraph2" 
# author: Alex T Kalinka and Pavel Tomancak
# modified by: Alfredo Ascanio
# date: "02/10/2017"
# e-mail: "11-10060@usb.ve"
# --- 

## plotLinkCommGraph2 presents a modification from the original 'plotLinkCommGraph' function.
## It takes the following code:
## lay <- layout.norm(lay, xmin = -1, xmax = 1, ymin = -1, ymax = 1)
## and, adding a parameter layout_dim = c(-2, 2, -1.2, -1) makes available
## the possibility to change the layout display dimensions

plotLinkCommGraph2 <- function (x, clusterids = 1:length(x$clusters), nodes = NULL, 
          layout = layout.fruchterman.reingold, pal = brewer.pal(7, 
                                                                 "Set2"), random = TRUE, node.pies = TRUE, pie.local = TRUE, 
          vertex.radius = 0.03, scale.vertices = 0.05, edge.color = NULL, 
          vshape = "none", vsize = 15, ewidth = 3, margin = 0, vlabel.cex = 0.8, 
          vlabel.color = "black", vlabel.family = "Helvetica", vertex.color = "palegoldenrod", 
          vlabel = TRUE, col.nonclusters = "black", jitter = 0.2, circle = TRUE, 
          printids = TRUE, cid.cex = 1, shownodesin = 0, showall = FALSE, 
          verbose = TRUE, layout_dim = c(-2, 2, -1.2, -1), ...) {
  if (length(nodes) > 0) {
    clusterids <- which.communities(x, nodes = nodes)
  }
  clusters <- x$clusters[clusterids]
  miss <- setdiff(x$hclust$order, unlist(clusters))
  crf <- colorRampPalette(pal, bias = 1)
  cols <- crf(length(clusters))
  if (random) {
    cols <- sample(cols, length(clusters), replace = FALSE)
  }
  if (showall) {
    single <- setdiff(1:x$numbers[1], unlist(clusters))
    ll <- length(clusters)
    for (i in 1:length(single)) {
      clusters[[(i + ll)]] <- single[i]
    }
    cols <- append(cols, rep(col.nonclusters, length(single)))
  }
  drawcircle <- FALSE
  if (class(layout) == "character") {
    if (layout == "spencer.circle") {
      if (length(clusters) > length(x$clusters[1:x$numbers[3]])) {
        clusterids <- 1:x$numbers[3]
      }
      ord <- orderCommunities(x, clusterids = clusterids, 
                              verbose = FALSE)
      clusters <- ord$ordered
      clusterids <- ord$clusids
      layout <- layout.spencer.circle(x, clusterids = clusterids, 
                                      jitter = jitter, verbose = verbose)$nodes
      drawcircle <- TRUE
    }
  }
  names(cols) <- clusterids
  if (length(unlist(clusters)) < nrow(x$edgelist) || length(miss) == 
      0) {
    edges <- x$edgelist[unlist(clusters), ]
    ig <- graph.edgelist(edges, directed = x$directed)
    clen <- sapply(clusters, length)
    j <- 1
    for (i in 1:length(clusters)) {
      newcids <- j:sum(clen[1:i])
      E(ig)[newcids]$color <- cols[i]
      j <- tail(newcids, 1) + 1
    }
  } else {
    ig <- x$igraph
    for (i in 1:length(clusters)) {
      E(ig)[clusters[[i]]]$color <- cols[i]
    }
  }
  if (shownodesin == 0) {
    vnames <- V(ig)$name
  } else {
    vnames <- V(ig)$name
    inds <- NULL
    for (i in 1:length(vnames)) {
      if (x$numclusters[which(names(x$numclusters) == vnames[i])] < 
          shownodesin) {
        inds <- append(inds, i)
      }
    }
    vnames[inds] <- ""
  }
  if (vlabel == FALSE) {
    vnames = NA
  }
  dev.hold()
  on.exit(dev.flush())
  oldpar <- par(no.readonly = TRUE)
  par(mar = c(4, 4, 2, 2))
  if (!node.pies) {
    plot(ig, layout = layout, vertex.shape = vshape, edge.width = ewidth, 
         vertex.label = vnames, vertex.label.family = vlabel.family, 
         vertex.label.color = vlabel.color, vertex.size = vsize, 
         vertex.color = vertex.color, margin = margin, vertex.label.cex = vlabel.cex, 
         ...)
  } else {
    nodes <- V(ig)$name
    if (pie.local) {
      edge.memb <- numberEdgesIn(x, clusterids = clusterids, 
                                 nodes = nodes)
    } else {
      edge.memb <- numberEdgesIn(x, nodes = nodes)
    }
    cat("   Getting node layout...")
    if (class(layout) == "function") {
      lay <- layout(ig)
    } else {
      lay <- layout
    }
    layout.norm(lay, xmin = layout_dim[1], xmax = layout_dim[2], 
                ymin = layout_dim[3], ymax = layout_dim[4])
    rownames(lay) <- V(ig)$name
    cat("\\n")
    node.pies <- .nodePie(edge.memb = edge.memb, layout = lay, 
                          nodes = nodes, edges = 100, radius = vertex.radius, 
                          scale = scale.vertices)
    cat("\\n")
    if (is.null(edge.color)) {
      plot(ig, layout = lay, vertex.shape = "none", vertex.label = NA, 
           vertex.label.dist = 2, edge.width = ewidth, vertex.label.color = vlabel.color,
           rescale = F,
           ...)
    }
    else {
      plot(ig, layout = lay, vertex.shape = "none", vertex.label = NA, 
           vertex.label.dist = 2, edge.width = ewidth, vertex.label.color = vlabel.color, 
           edge.color = edge.color, rescale = F, ...)
    }
    labels <- list()
    for (i in 1:length(node.pies)) {
      yp <- NULL
      for (j in 1:length(node.pies[[i]])) {
        seg.col <- cols[which(names(cols) == names(edge.memb[[i]])[j])]
        polygon(node.pies[[i]][[j]][, 1], node.pies[[i]][[j]][, 
                                                              2], col = seg.col)
        yp <- append(yp, node.pies[[i]][[j]][, 2])
      }
      lx <- lay[which(rownames(lay) == names(node.pies[i])), 
                1] + 0.1
      ly <- max(yp) + 0.02
      labels[[i]] <- c(lx, ly)
    }
    for (i in 1:length(labels)) {
      text(labels[[i]][1], labels[[i]][2], labels = vnames[which(nodes == 
                                                                   names(node.pies[i]))], cex = vlabel.cex, col = vlabel.color)
    }
  }
  if (circle && drawcircle) {
    cx <- NULL
    for (i in 1:100) {
      cx[i] <- 1.25 * cos(i * (2 * pi)/100)
    }
    cy <- NULL
    for (i in 1:100) {
      cy[i] <- 1.25 * sin(i * (2 * pi)/100)
    }
    polygon(cx - 0.08, cy - 0.08, border = "grey", lwd = 2)
    for (i in 1:length(clusters)) {
      px <- 1.1 * cos(i * (2 * pi)/length(clusters))
      py <- 1.1 * sin(i * (2 * pi)/length(clusters))
      points(px - 0.08, py - 0.08, pch = 20, col = cols[i])
      if (printids) {
        tx <- 1.3 * cos(i * (2 * pi)/length(clusters))
        ty <- 1.3 * sin(i * (2 * pi)/length(clusters))
        text(tx - 0.08, ty - 0.08, labels = clusterids[i], 
             col = cols[i], cex = cid.cex, font = 2)
      }
    }
  }
  par(oldpar)
}

environment(plotLinkCommGraph2) <- environment(plotLinkCommGraph)
