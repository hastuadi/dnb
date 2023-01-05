{
  rm(list = ls()); while(!is.null(dev.list()))dev.off()
  suppressWarnings(suppressPackageStartupMessages({
    library(magrittr); library(data.table); library(ggplot2); library(terra); library(tidyterra); library(EBImage)
    library(RColorBrewer); library(rworldmap); library(rworldxtra)
  }))
  
  ubah.inf <- function(input, fungsi = mean) {
    nilai <- fungsi(input, na.rm = TRUE)
    input[is.na(input) | is.nan(input) | is.infinite(input)] <- nilai
    return(input)
  }
  
  nama.file <- '../dnbviirs/10082021_1831076.tif'
  
  isi.file <- rast(nama.file)
  
  crs.str <- crs(isi.file); eksten <- ext(isi.file)
  
  to.raster <- function(input) input %>% rast(crs = crs.str, ext = eksten)
  
  peta <- getMap('high') %>% sf::st_as_sf() %>% vect
  peta <- crop(peta, eksten)
}

# display(isi.file %>% as.array %>% transpose)

isi.file.10_9 <- isi.file * 10^9
# display(isi.file.10_9 %>% as.array %>% transpose)

isi.file.10_9.log <- isi.file.10_9 %>% log10
# display(isi.file.10_9.log %>% as.array %>% transpose)

isi.file.10_9.log[is.infinite(isi.file.10_9.log)] <- NA
isi.file.10_9.log[is.na(isi.file.10_9.log)] <- minmax(isi.file.10_9.log)[1]

isi.file.10_9.log.median <- isi.file.10_9.log %>% 
  as.array %>% 
  medianFilter(3) %>% 
  to.raster

isi.file.10_9.log.median.selisih <- isi.file.10_9.log - isi.file.10_9.log.median

nilai.threshold <- 0.035 %>% log10

smi <- isi.file.10_9.log.median.selisih
smi[smi < nilai.threshold] <- NA

display(smi %>% as.array %>% transpose)

data.translate <- isi.file.10_9.log %>% 
  as.array %>% 
  translate(c(1, 0)) %>% 
  to.raster
data.translate.rata2 <- (data.translate + isi.file.10_9.log) / 2

data.h <- (isi.file.10_9.log - data.translate.rata2) / isi.file.10_9.log

data.translate <- isi.file.10_9.log %>% 
  as.array %>% 
  translate(c(0, 1)) %>% 
  to.raster
data.translate.rata2 <- (data.translate + isi.file.10_9.log) / 2

data.v <- (isi.file.10_9.log - data.translate.rata2)# / isi.file.10_9.log

data.vh <- data.v + data.h
display(data.vh %>% as.array %>% transpose)

# isi.file.10_9.log.median.selisih.th <- isi.file.10_9.log.median.selisih
# isi.file.10_9.log.median.selisih.th[isi.file.10_9.log.median.selisih.th < nilai.threshold] <- NA
# # display(isi.file.10_9.log.median.selisih.th %>% as.array %>% transpose)
# 
# isi.file.10_9.log.median.selisih.th.mask <- isi.file.10_9.log.median.selisih.th %>% 
#   mask(peta, inverse = TRUE)
# 
# # display(isi.file.10_9.log.median.selisih.th.mask %>% as.array %>% transpose)
# # display(isi.file.10_9.log.median.selisih.th.mask %>% as.array %>% normalize %>% transpose)
# 
# isi.translate <- isi.file.10_9.log.median.selisih.th.mask %>% 
#   as.array %>% 
#   translate(c(1, 0)) %>% 
#   to.raster
# 
# isi.translate.rata2 <- (isi.file.10_9.log.median.selisih.th.mask + isi.translate) / 2
# 
# isi.file.10_9.log.median.selisih.th.mask.h <- (isi.file.10_9.log.median.selisih.th.mask - isi.translate.rata2) / 
#   isi.file.10_9.log.median.selisih.th.mask
# 
# display(isi.file.10_9.log.median.selisih.th.mask.h %>% as.array %>% transpose)
# 
# # isi.file.translate <- isi.file.10_9.log.median.selisih.th.mask %>% 
# #   as.array %>% 
# #   translate(c(1, 0)) %>% 
# #   to.raster
# # 
# # isi.file.translate.rata2 <- (isi.file.10_9.log.median.selisih.th.mask + isi.file.translate) / 2
# # 
# # isi.file.10_9.log.median.selisih.th.mask.h <- (isi.file.10_9.log.median.selisih.th.mask - isi.file.translate.rata2) / 
# #   isi.file.10_9.log.median.selisih.th.mask
# # 
# # display(isi.file.10_9.log.median.selisih.th.mask.h %>% as.array %>% transpose)
# # 
# # isi.file.translate <- isi.file.10_9.log.median.selisih.th.mask %>% 
# #   as.array %>% 
# #   translate(c(0, 1)) %>% 
# #   to.raster
# # 
# # isi.file.translate.rata2 <- (isi.file.10_9.log.median.selisih.th.mask + isi.file.translate) / 2
# # 
# # isi.file.10_9.log.median.selisih.th.mask.v <- (isi.file.10_9.log.median.selisih.th.mask - isi.file.translate.rata2) / 
# #   isi.file.10_9.log.median.selisih.th.mask
# # 
# # isi.file.10_9.log.median.selisih.th.mask.vh <- isi.file.10_9.log.median.selisih.th.mask.v +
# #   isi.file.10_9.log.median.selisih.th.mask.h
# # 
# # display(isi.file.10_9.log.median.selisih.th.mask.vh %>% as.array %>% transpose)
