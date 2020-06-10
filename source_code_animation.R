rm(list = ls()) # clear memory

# loading packages

library(animation)

# loading and modifying dataset

uri <- 'https://raw.githubusercontent.com/fellypesb/mapa_covid/master/dataset/casos_diarios_para.csv'
cases <- read.csv(uri)

cases$Datas <- as.Date(cases$Datas, format('%d/%m/%Y'))

# create and save frames in format GIF

saveGIF(movie.name = 'covid_animation.gif',
        interval=.1,
        ani.height=522,
        ani.width=722,
        ani.res=120,{
  for (x in 2:nrow(cases)) {
    plot(cases$Datas[1:x], cases$Casos_total[1:x],
         type = 'l',
         col = 'red',
         xlim = range(cases$Datas),
         ylim = range(cases$Casos_total),
         xlab = 'Datas',
         ylab = 'Infectados',
         main = 'Casos Covid-19 no Pará')
  }
})



