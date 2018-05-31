# --- 
# title: "plotLinkCommMembers2" 
# author: Alex T Kalinka and Pavel Tomancak
# modified by: Alfredo Ascanio
# date: "02/10/2017"
# e-mail: "11-10060@usb.ve"
# --- 

## plotLinkCommMembers2 takes the original linkcomm 'plotLinkCommMembers' and
## adds several parameters to change the fontsize in the graphic display.
## These parameters were: 
## sigmafont = the size of the sigma symbol
## comfont = the size of the communities id number
## sumfont = the size of the sum value

plotLinkCommMembers2 <- function (x, nodes = head(names(x$numclusters), 10), pal = brewer.pal(11, 
                                                                      "Spectral"), shape = "rect", total = TRUE, 
                                  fontsize = 11, sigmafont = 10, comfont = 8, sumfont = 8, 
                                  title = T, nspace = 3.5, maxclusters = 20) 
{
  comms <- unique(x$nodeclusters[as.character(x$nodeclusters[, 
                                                             1]) %in% nodes, 2])
  if (length(comms) > maxclusters) {
    comms <- comms[1:maxclusters]
  }
  commatrix <- getCommunityMatrix(x, nodes = nodes)
  crf <- colorRampPalette(pal, bias = 1)
  cols <- crf(length(comms))
  grid.newpage()
  if (total) {
    C <- 2
    R <- 3
    nodesums <- apply(commatrix, 1, sum)
    commsums <- apply(commatrix, 2, sum)
  }
  else {
    C <- 1
    R <- 2
  }
  margin <- unit(0.1, "lines")
  pushViewport(viewport(x = 1, y = 1, width = unit(1, "npc") - 
                          2 * margin, height = unit(1, "npc") - 2 * margin, just = c("right", 
                                                                                     "top")))
  pushViewport(viewport(layout = grid.layout(nrow = length(nodes) + 
                                               R, ncol = length(comms) + C, widths = unit(c(nspace, 
                                                                                            rep(1, length(comms) + C - 1)), rep("null", length(comms) + 
                                                                                                                                  C)), heights = unit(rep(1, length(nodes) + R), rep("null", 
                                                                                                                                                                                     length(nodes) + R)), respect = TRUE)))
  pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 2:length(comms) + 
                          1))
  if(title) {
    ctitle <- grid.text("Community Membership", x = unit(0.5, 
                                                         "npc"), y = unit(0.5, "npc"), draw = FALSE, name = "ctitle")
    ctitle <- editGrob(ctitle, gp = gpar(fontsize = 10))
    grid.draw(ctitle)
  }
  
  popViewport(1)
  for (i in 1:(length(nodes) + R - 2)) {
    if (i != length(nodes) + 1) {
      pushViewport(viewport(layout.pos.row = i + 2, layout.pos.col = 1))
      nname <- grid.text(as.character(nodes[i]), x = unit(0.9, 
                                                          "npc"), y = unit(0.5, "npc"), draw = FALSE, name = "nname")
      nname <- editGrob(nname, gp = gpar(fontsize = fontsize), 
                        just = "right")
      grid.draw(nname)
      popViewport(1)
    }
    for (j in 1:(length(comms) + C - 1)) {
      if (total && j == length(comms) + 1 && i != length(nodes) + 
          1) {
        pushViewport(viewport(layout.pos.row = i + 2, 
                              layout.pos.col = j + 1))
        ntot <- grid.text(nodesums[i], x = unit(0.5, 
                                                "npc"), y = unit(0.5, "npc"), draw = FALSE, 
                          name = "ntot")
        ntot <- editGrob(ntot, gp = gpar(fontsize = sumfont))
        grid.draw(ntot)
        popViewport(1)
        if (i == 1) {
          pushViewport(viewport(layout.pos.row = 2, layout.pos.col = j + 
                                  1))
          rt <- grid.text(expression(Sigma), x = unit(0.5, 
                                                      "npc"), y = unit(0.5, "npc"), draw = FALSE, 
                          name = "rt")
          rt <- editGrob(rt, gp = gpar(fontsize = sigmafont))
          grid.draw(rt)
          popViewport(1)
        }
      }
      else {
        if (i == 1 && j != length(comms) + 1) {
          pushViewport(viewport(layout.pos.row = 2, layout.pos.col = j + 
                                  1))
          rtitle <- grid.text(comms[j], x = unit(0.5, 
                                                 "npc"), y = unit(0.5, "npc"), draw = FALSE, 
                              name = "rtitle")
          rtitle <- editGrob(rtitle, gp = gpar(fontsize = comfont))
          grid.draw(rtitle)
          popViewport(1)
        }
        if (total && i == length(nodes) + 1 && j != length(comms) + 
            1) {
          if (j == 1) {
            pushViewport(viewport(layout.pos.row = i + 
                                    2, layout.pos.col = 1))
            ct <- grid.text(expression(Sigma), x = unit(0.9, 
                                                        "npc"), y = unit(0.5, "npc"), draw = FALSE, 
                            name = "ct")
            ct <- editGrob(ct, gp = gpar(fontsize = sigmafont))
            grid.draw(ct)
            popViewport(1)
          }
          pushViewport(viewport(layout.pos.row = i + 
                                  2, layout.pos.col = j + 1))
          ctot <- grid.text(commsums[j], x = unit(0.5, 
                                                  "npc"), y = unit(0.5, "npc"), draw = FALSE, 
                            name = "ctot")
          ctot <- editGrob(ctot, gp = gpar(fontsize = sumfont))
          grid.draw(ctot)
          popViewport(1)
        }
        else if (i != length(nodes) + 1 && j != length(comms) + 
                 1) {
          if (commatrix[i, j] == 1) {
            fill <- cols[j]
          }
          else {
            fill <- "white"
          }
          if (shape == "rect") {
            pushViewport(viewport(layout.pos.row = i + 
                                    2, layout.pos.col = j + 1))
            grid.rect(gp = gpar(fill = fill, col = "grey"), 
                      width = unit(0.9, "npc"), height = unit(0.9, 
                                                              "npc"), draw = TRUE)
            popViewport(1)
          }
          else if (shape == "circle") {
            pushViewport(viewport(layout.pos.row = i + 
                                    2, layout.pos.col = j + 1))
            grid.circle(x = 0.5, y = 0.5, r = 0.45, gp = gpar(fill = fill, 
                                                              col = "grey"), draw = TRUE)
            popViewport(1)
          }
        }
      }
    }
  }
}
environment(plotLinkCommMembers2) <- environment(linkcomm2clustnsee)