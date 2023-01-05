{
  rm(list = ls())
  while(!is.null(dev.list()))dev.off()
  library(dplyr)
  library(ggplot2)
  library(data.table)
  library(terra)
  library(EBImage)
  library(RColorBrewer)
  library(sf)
}

eksten <- ext(102, 116, -10, -3)

isi.file <- rast('../dnbviirs/10082021_1831076.tif')
isi.file <- crop(isi.file, eksten)

peta <- map_data('world2') 

ggplot() +
  geom_polygon(aes(long, lat, group = group), peta)

# {
#   rm(list = ls())
#   while(!is.null(dev.list()))dev.off()
#   library(dplyr)
#   library(ggplot2)
#   library(data.table)
#   library(terra)
#   library(EBImage)
#   library(RColorBrewer)
# }
# 
# {
#   eksten <- ext(102, 116, -10, -3)
#   
#   isi.file <- rast('../dnbviirs/10082021_1831076.tif') 
#   isi.file <- crop(isi.file, eksten)
#   
#   isi.file.dnb <- isi.file * 10^9
#   rentang <- minmax(isi.file.dnb) %>% as.vector  
#   isi.file.dnb <- isi.file.dnb %>% 
#     '-'(rentang[1]) %>% 
#     '+'(1) %>% 
#     log10
#   
#   isi.file.dnb.matrix <- matrix(isi.file.dnb, ncol(isi.file.dnb))
#   
#   display(isi.file.dnb.matrix %>% normalize())
# }
# 
# isi.file.dnb.matrix.med <- medianFilter(isi.file.dnb.matrix, 2)
# display(isi.file.dnb.matrix.med %>% normalize)
# 
# isi.file.dnb.med <- isi.file.dnb.matrix - isi.file.dnb.matrix.med
# display(isi.file.dnb.med)
# 
# data.grafik <- data.table(
#   dnb = isi.file.dnb.matrix %>% as.vector %>% log10,
#   smi = isi.file.dnb.matrix.med %>% as.vector %>% log10
# )
# 
# warna <- colorRampPalette(c('white', 'black'))(11)
# warna <- brewer.pal(11, 'Spectral')
# 
# ggplot() +
#   stat_density_2d(
#     aes(dnb, smi, fill = ..density..), data.grafik, geom = 'raster', contour = FALSE
#   ) +
#   scale_fill_gradientn(colors = warna) +
#   theme_bw() +
#   theme(legend.position = 'none')
# 
# ggplot() +
#   geom_density(aes(smi), data.grafik)
# 
# isi.avg <- 
# # {
# #   rm(list = ls())
# #   while(!is.null(dev.list()))dev.off()
# #     
# #   library(dplyr)
# #   library(data.table)
# #   library(terra)
# #   library(EBImage)
# #     
# # }
# # 
# # isi.file <- rast('../dnbviirs/10082021_1831076.tif') 
# # dimensi <- dim(isi.file)[1:2]
# # 
# # isi.file.matrix <- matrix(isi.file, dimensi[2]) %>% 
# #   '*'(10^9) %>% 
# #   '-'(min(.)) %>% 
# #   '+'(1) %>% 
# #   log10
# # 
# # isi.file.matrix.norm <- isi.file.matrix %>% 
# #   normalize
# # 
# # isi.file.matrix.norm <- rast(isi.file.matrix.norm)
# # 
# # isi.file.matrix.median <- medianFilter(isi.file.matrix, size = 7)
# # display(isi.file.matrix.median %>% normalize)
# # 
# # isi.file.dnb <- isi.file %>% 
# #   '*'(10^9)
# # 
# # rentang <- minmax(isi.file.dnb) %>% as.vector
# # 
# # isi.file.dnb <- isi.file.dnb %>% 
# #   '-'(rentang[1]) %>% 
# #   '+'(1) %>% 
# #   log10
# # 
# # ext(isi.file.dnb) <- c(110, 120, -10, -4)
# # 
# # isi.file.dnb.matrix <- isi.file.dnb %>% 
# #   matrix(nrow(isi.file.dnb))
# # 
# # isi.file.dnb.matrix <- medianFilter(isi.file.dnb.matrix, 1)
# # {
# #   rm(list = ls())
# #   while(!is.null(dev.list()))dev.off()
# #   
# #   suppressWarnings(suppressPackageStartupMessages({
# #     library(dplyr)
# #     library(ggplot2)
# #     library(data.table)
# #     library(terra)
# #     library(tidyterra)
# #     library(EBImage)
# #     library(RColorBrewer)
# #     library(sf)
# #     library(rworldmap)
# #     library(rworldxtra)
# #   }))
# # }
# # 
# # daftar.file <- list.files('../dnbviirs/', full.names = TRUE)[-3]
# # 
# # isi.file <- lapply(daftar.file, rast) 
# # 
# # eksten <- lapply(isi.file, ext)
# # 
# # isi.file.olah <- lapply(isi.file, function(in1) {
# #   in1 <- in1 * 10^9
# #   jumlah.baris <- nrow(in1)
# #   rentang <- minmax(in1)
# #   in1 %>% 
# #     '-'(rentang[1]) %>%
# #     '+'(1) %>% 
# #     log10 %>% 
# #     matrix(ncol = jumlah.baris) 
# # })
# # 
# # display(isi.file.olah[[1]])
# # 
# # isi.file.median <- lapply(
# #   isi.file.olah, medianFilter, 3
# # )
# # 
# # display(isi.file.median[[1]])
# # display(isi.file.median[[1]] %>% normalize)
# # 
# # isi.file.xy <- purrr::map2(isi.file.olah, isi.file.median, ~{
# #   .x - .y
# # })
# # 
# # isi.file.yx <- purrr::map2(isi.file.olah, isi.file.median, ~{
# #   .y - .x
# # })
# # 
# # display(isi.file.xy[[1]] %>% normalize)
# # display(isi.file.yx[[1]])
# # 
# # hist(isi.file.sub[[3]] %>% normalize())
