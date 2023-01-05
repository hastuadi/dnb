{
  rm(list = ls())
  while(!is.null(dev.list()))dev.off()
  
  library(dplyr)
  library(data.table)
  library(ggplot2)
  library(rworldmap)
  library(rworldxtra)
  library(EBImage)
  library(RColorBrewer)
  library(terra)
  library(tidyterra)
  
}

peta <- getMap('high') %>% 
  sf::st_as_sf() %>% 
  vect

viirs <- rast('../dnbviirs/10082021_1831076.tif')

viirs.billion <- viirs * (10^9)
viirs.billion[viirs.billion <= 0] <- 10^-9
viirs.log <- log10(viirs.billion)

viirs.median <- medianFilter(viirs.log %>% as.array %>% .[,,1], 2) %>% 
  rast(crs = crs(viirs), ext = ext(viirs))

viirs.smi <- viirs.log - viirs.median

nilai.threshold <- .035

viirs.threshold <- viirs.smi
viirs.threshold[viirs.threshold <= nilai.threshold] <- NA

viirs.sea <- mask(viirs.threshold, peta, inverse = TRUE)

data.koordinat <- data.table(
  xyFromCell(viirs.sea, 1:ncell(viirs.sea)),
  nilai = terra::extract(viirs.sea, 1:ncell(viirs.sea)) %>% unlist
)[!(is.na(nilai) | is.nan(nilai))]

data.koordinat[, unique(nilai)]

data.shp <- vect('../VBD_npp_d20210810_idn_noaa_ops_v23/VBD_npp_d20210810_idn_noaa_ops_v23.shp')

eksten <- ext(data.shp)

ggplot() +
  geom_spatvector(data = data.shp) +
  geom_spatraster(data = viirs.sea) +
  coord_sf(xlim = eksten[1:2], ylim = eksten[3:4]) +
  scale_fill_gradientn(colors = c('red', 'red'), na.value = NA) +
  theme_minimal() +
  theme(legend.position = 'none')

data.koordinat.shp <- vect(data.koordinat[between(x, eksten[1], eksten[2]) & between(y, eksten[3], eksten[4]), .(x, y)], c('x', 'y'), crs(viirs))

writeVector(data.koordinat.shp, 'datakoordinat.kml', overwrite = TRUE)

data.shp.dt <- data.shp %>% 
  as.data.frame(xy = TRUE) %>% 
  setDT
