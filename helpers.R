mapfunc <- function(df){
  m <- map1 + geom_density2d(data=df, aes(x=Lon, y=Lat), color = "grey40") +
    stat_density2d(data=df, aes(x=Lon, y=Lat, fill=..level.., alpha=..level..), 
                   size = 1, bins = 16, geom='polygon') +
    scale_fill_gradient(low = "green", high = "red") +
    scale_alpha(range = c(0.00, 0.25), guide = FALSE) +
    theme(legend.position = "none", axis.title = element_blank(), text = element_text(size = 12))
  print(m)
}

