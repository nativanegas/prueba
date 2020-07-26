library(tidyverse)
library(RSocrata)
library(dygraphs)
library(xts)
library(incidence)
token <- "ew2rEMuESuzWPqMkyPfOSGJgE" #Es una herramienta para poder descargar los datos desde el INS.
df.ins <- read.socrata("https://www.datos.gov.co/resource/gt2j-8ykr.json", app_token = token) #Descarga los datos desde la página de la INS.
df.ins$fis <- as.Date(df.ins$fis, format = "%Y-%m-%d")
df.ins$fecha_de_notificaci_n <- as.Date(df.ins$fecha_de_notificaci_n, format = "%Y-%m-%d")
df.ins$fecha_de_muerte <- as.Date(df.ins$fecha_de_muerte, format = "%Y-%m-%d")
df.ins$fecha_recuperado <- as.Date(df.ins$fecha_recuperado, format = "%Y-%m-%d")
df.ins$fecha_fecha_reporte_web <- as.Date(df.ins$fecha_reporte_web, format = "%Y-%m-%d")
df.ins$fecha_fecha_diagnostico  <- as.Date(df.ins$fecha_diagnostico, format = "%Y-%m-%d")


df.ins$confirmados <- "Confirmados"

df.ins <- df.ins %>%
  dplyr::select(id_de_caso,
                ciudad_de_ubicaci_n,
                confirmados,
                fecha_de_notificaci_n,
                fis,
                fecha_fecha_diagnostico,
                fecha_de_muerte,
                fecha_fecha_reporte_web,
                everything())

saveRDS(df.ins, file = "data/Colombia.RDS")
df.ins.colombia=readRDS("data/Colombia.RDS")
inc.casos.colombia.confirmados <- incidence(df.ins.colombia$fecha_fecha_reporte_web,
                                     groups = df.ins.colombia$confirmados)
serie.colombia <- xts(x = inc.casos.colombia.confirmados$counts,
                      order.by = inc.casos.colombia.confirmados$dates)

plot1_time <- dygraph(serie.colombia) %>% 
  dyRangeSelector(dateWindow = c("2020-03-03", "2020-07-25"))  

#inc.casos.colombia.confirmados <- incidence(df.ins.colombia$fecha_de_notificaci_n,
   #                                         groups = df.ins.colombia$atenci_n=="Fallecidos")
#serie.colombia <- xts(x = inc.casos.colombia.confirmados$counts,
  #                    order.by = inc.casos.colombia.confirmados$dates)

#plot1_time <- dygraph(serie.colombia) %>% 
 # dyRangeSelector(dateWindow = c("2020-03-03", "2020-07-25"))  


df.ins.colombia <- df.ins.colombia %>% mutate(sexo = replace(sexo, sexo == "m", "M"))
df.ins.colombia <- df.ins.colombia %>% mutate(sexo = replace(sexo, sexo == "f", "F"))

inc.casos.colombia.sexo <- incidence(df.ins.colombia$fecha_fecha_reporte_web,
                                     groups = df.ins.colombia$sexo)

serie.colombia.sexo <- xts(x = inc.casos.colombia.sexo$counts,
                      order.by = inc.casos.colombia.sexo$dates)

plot2_time <- dygraph(serie.colombia.sexo) %>% 
  dyRangeSelector(dateWindow = c("2020-03-03", "2020-07-25"))

