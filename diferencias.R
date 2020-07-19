library(forecast)
library(tseries)
library(ggfortify)
library(stringr)
library(RSocrata)

token <- "ew2rEMuESuzWPqMkyPfOSGJgE"
df.ins <- read.socrata("https://www.datos.gov.co/resource/gt2j-8ykr.json", app_token = token)
fecha=str_sub(df.ins$fecha_diagnostico,1,10)

fecha=str_sub(df.ins$fecha_diagnostico,6,10)
tabla=table(fecha)
plot(tabla) #Casos diarios reportados
plot(diff(tabla)) #Diferencia

