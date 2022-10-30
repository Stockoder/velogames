library("readr")
library("ggplot2")
library("magrittr")
library("dplyr")
library("fs")

cols <- c("Rider","Team","Class","Cost","Stg","GC","PC","KOM","Spr","Sum","Bky","Ass","Tot")
files <- dir_ls(path="/cloud/project/data/velogames",glob = "*rider_data*csv")


for (i in seq(1:length(files))) {
  message("Reading file",i,":", files[i])
  d <- read_csv(files[i],col_select = cols,show_col_types = FALSE)
  d <- mutate(d,Race=as.char(gsub("_velogames_rider_data.csv","",gsub("/cloud/project/data/velogames/","",files[i]))),.after=Rider)
  if (i==1){
    vg <- d
  } else {
    vg <- bind_rows(vg, d)
  }
}

vg <- vg %>%
  mutate(Ratio = Tot/Cost) %>%
  arrange(desc(Ratio))
         
head(vg)

ggplot(data=vg, aes(x=Cost, y=Ratio, color=Class)) +
  geom_point(alpha=.4)