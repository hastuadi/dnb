{
  rm(list = ls())
  while(!is.null(dev.list()))dev.off()
  suppressWarnings(suppressPackageStartupMessages({
    library(dplyr)
    library(data.table)
    library(terra)
    library(EBImage)
    library(sf)
    library(ggplot2)
    library(tidyterra)
    library(RColorBrewer)
    library(rworldmap)
    library(rworldxtra)
    library(leaflet)
  }))
}

fungsi.plot <- function(data.input) {
  ggplot() +
    geom_spatraster(data = data.input) +
    geom_sf(data = peta, fill = 'green', color = 'green') +
    coord_sf(xlim = ekstent[1:2], ylim = ekstent[3:4]) +
    scale_fill_gradientn(colors = warna, na.value = 'black') +
    xlab('') + ylab('') +
    theme_minimal() +
    theme(legend.title = element_blank())
}

warna <- colorRampPalette(c('black', 'white'))(256)
peta <- map_data('world2')
peta <- getMap('high') %>% 
  st_as_sf

ekstent <- ext(105, 115, -10, -3)

data.input <- rast('../dnbviirs/10082021_1831076.tif') 
data.input <- crop(data.input, ekstent)
data.input[data.input <= 0] <- 10^-9

fungsi.mask <- function(input) {
  peta.rast <- vect(peta)
  hasil.mask <- mask(input, peta.rast, inverse = TRUE) 
  lokasi <- data.table(
    hasil.mask %>%
      terra::xyFromCell(1:ncell(input)),
    nilai = hasil.mask %>%
      terra::extract(1:ncell(input)) %>% unlist
  )
  lokasi[!(is.na(nilai) | is.nan(nilai))]
}

dnb <- data.input %>% 
  as.array %>% 
  .[,,1] %>% 
  rotate(90) %>% 
  flop 

dnb.billion <- dnb * (10^9)
dnb.log <- log10(dnb.billion)

display(dnb.log %>% normalize)

dnb.median <- medianFilter(dnb.log, 2)

dnb.smi <- dnb.log - dnb.median

dnb.smi.raster <- rast(dnb.smi %>% rotate(90) %>% flop, crs = '+proj=longlat', extent = ekstent)

dnb.smi.raster.threshold <- dnb.smi.raster
dnb.smi.raster.threshold[dnb.smi.raster <= 0.035] <- NA

fungsi.plot(dnb.smi.raster)
fungsi.plot(dnb.smi.raster.threshold)

koordinat <- fungsi.mask(dnb.smi.raster.threshold) 

fwrite(koordinat, 'data_koordinat.')
peta.leaflet <- leaflet(data = koordinat) %>% #[between(x, 108, 110) & between(y, -10, -8)]) %>% 
  addTiles() %>% 
  addCircles(lng = ~x, lat = ~y)

peta.leaflet
