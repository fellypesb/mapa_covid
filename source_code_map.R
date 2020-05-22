rm(list = ls()) # clear memory

# loading packages

library(magrittr)
library(geobr)
library(dplyr)
library(stringr)
library(ggplot2)
library(ggspatial)
library(grid)
library(cowplot)
library(curl)

# loading and modifying dataset

uri <- 'https://raw.githubusercontent.com/fellypesb/mapa_covid/master/dataset/covid19_munic_pa_20200519.csv'
covid <- read.csv(uri)
cases_city <- as.data.frame(table(covid$Município)) %>% rename(name_muni=Var1)
cases_city[1] <- str_to_title(cases_city$name_muni)

# loading geographic coordenates 

coord_city <- read_municipality(code_muni = "PA", year = 2018)

# joining dataframes

data_map = full_join(coord_city, cases_city, by='name_muni')
data_map$Freq[is.na(data_map$Freq)] <- 0 # clear nan

# setting labels 

data_map$labels <- cut(data_map$Freq,breaks=c(-1,20,100,400,1000,3000,6000,Inf),
    labels=c("0 - 20", "21 - 100", "101 - 400",
             "401 - 1000","1001 - 3000", "3001 - 6000", "6000+"))
  
# plotting map

plot_map <- ggplot()+
  geom_sf(data=data_map, aes(fill=labels),)+
  scale_fill_manual(values = c("#FADDE2", "#E6B2B5","#D48C90","#C1666B",
                                 "#96474B","#6C292B","#301616"))+
  annotation_scale(location="bl",height = unit(0.13, "cm"),bar_cols = c("#96474B","white"))+
  annotation_north_arrow(location="tr",
                         style=north_arrow_nautical,
                         height = unit(3,"cm"),
                         width = unit(3, "cm"))+
  labs(title="Casos de Covid-19 no Pará",
       caption = "Atualizado em 19/05/2020",
       fill="Casos \nConfirmados",
       x=element_blank(),
       Y=element_blank())+
  theme_minimal()+
  theme(legend.position = c(.899,.18),
        legend.key.size = unit(6, "mm"),
        legend.title.align = 0.5,
        plot.title = element_text(family="Roboto",
                                  face="bold",
                                  size=18,
                                  hjust = 0.5,
                                  color="#2D3E50"),
        legend.title = element_text(family="Roboto",
                                    face="bold",
                                    size=9.5,
                                    color="#2D3E50"),
        legend.text = element_text(family = "Roboto",
                                   face = "bold",
                                   color ="#2D3E50"),
        plot.caption = element_text(size = 7,
                                    face = "italic"))

p <- plot_grid(plot_map)
# add annotations
  
sysfonts::font_add_google(name = "Roboto", family = "Roboto") # add special text font
t1 <- grid::textGrob(expression(bold("Script:")), 
                     gp = gpar(fontsize=13, col="#2D3E50", fontfamily = "Roboto"), x = 0.1, y = 0.02)
t2 <- grid::textGrob(expression(underline("https://github.com/fellypesb/mapa_covid")), 
                     gp = gpar(fontsize=9, col="#000066"), x = 0.35, y = 0.02)

annotate <- annotation_custom(grobTree(t1, t2))

full_map <- p + annotate

full_map

# save plot

ggsave(plot=last_plot(),
       filename = "./plot_map_covid.png",
       dpi = 300)
