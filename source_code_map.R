rm(list = ls()) # clear memory

# loading packages

library(magrittr)
library(geobr)
library(dplyr)
library(stringr)
library(ggplot2)

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

# plotting map

ggplot(data_map)+geom_sf(aes(fill=Freq)) 

