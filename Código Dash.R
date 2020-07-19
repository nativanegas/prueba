library(sf) #Contiene funciones para codificar datos espaciales.
library(ggplot2) #Sirve para crear gráficos y mapear
library(tmap) #Importa mapas temáticos en los cuales se visualizan las distribuciones de datos espaciales.
library(tmaptools) #Conjunto de herramientas para leer y procesar datos espaciales.
library(leaflet) #Crea y personaliza mapas interactivos usando una biblioteca de JavaScript
library(dplyr) #Sirve para manipular datos.
library(rgdal) #Proporciona enlaces a la Biblioteca de abstracción de datos 'geoespaciales' y acceso
#a las operaciones de proyección desde la biblioteca 'PROJ'. 
library(sp) #Clases y métodos para datos espaciales.
library(readxl) #Importa archivos de excel a R.
library(RSocrata) #Proporciona una interacción más fácil con los portales de datos abiertos.
library(mapview)
token <- "ew2rEMuESuzWPqMkyPfOSGJgE" #Es una herramienta para poder descargar los datos desde el INS.
df.ins <- read.socrata("https://www.datos.gov.co/resource/gt2j-8ykr.json", app_token = token) #Descarga los datos desde la página de la INS.
mapa=readOGR("/Users/Natalia/Desktop/TESIS/depto/depto.shp",stringsAsFactors=FALSE) #Exporta los datos para crear el mapa de Colombia dividio por departamentos
dashboard=st_read("/Users/Natalia/Desktop/TESIS/depto/depto.shp",stringsAsFactors=FALSE) #Exporta las características de cada departamento de Colombia
plot(mapa,main="COLOMBIA") #Crea el mapa de Colombia
str(mapa) #Muestra de forma compacta la estructura interna de un objeto.

df.ins$codigo=NA #Crea una nueva columna sin datos.
df.ins$codigo=trunc(as.numeric(df.ins$c_digo_divipola)/1000) #A la columna creada le asigna el valor del código divipola 
#dividido por 1000, el cual es igual al código del dpto.
tabla=table(df.ins$codigo,df.ins$atenci_n) #Crea una tabla que cuenta la cantidad de atendidos dependiendo del código de dpto.

dashboard=arrange(dashboard, as.numeric(DPTO)) #Organiza de menor a mayor la base dashboard dependiendo del cód. de dpto.
rownames(tabla)=dashboard$NOMBRE_DPT #A cada fila de la tabla (23) se le asigna el nombre de cada departamento 
tabla[,1]=tabla[,1]+tabla[,3]+tabla[,4] #Se suma atención: casa, hospital y hospital UCI.
tabla=tabla[,-c(3:5)] #Se eliminan las columnas hospital, hospital UCI y NA.
TOTAL_CONTAGIADOS=tabla[,1]+tabla[,2]+tabla[,3] #Crea una columna con la suma de las columnas existentes.

write.csv(tabla, file="covid19.csv") #Guarda en un archivo .csv la tabla creada.
covid19=read.csv("/Users/Natalia/Desktop/TESIS/DASHBOARD/covid19.csv") #Exporta el archivo creado anteriormente.
covid19=data.frame(covid19,TOTAL_CONTAGIADOS) #Concatena el archivo anterior con el total de contagiados.
names(covid19)=cbind("NOMBRE_DPT","CASOS ACTIVOS","FALLECIDOS","RECUPERADOS","TOTAL CONTAGIADOS") #Renombra las columnas.
dashboard=dashboard[,-1] #Elimina la primera columna de la base dashboard.

mapview(covid19[,2],layer.name="Total")

mapa_datos=inner_join(dashboard,covid19)#Une las bases dashboard y covid 19.
mapa_datos=mapa_datos[,-c(2:4)] #Elimina las columnas 2 a 4 de la base creada anteriormente.
tm_shape(mapa_datos)+
  tm_layout(title = "CASOS DE COVID-19 EN COLOMBIA. Realizado por: Natalia Vanegas")+
  tm_polygons("MAP_COLORS") #Crea el mapa estático de Colombia dependiendo de los datos anteriores.
  
test_map=tmap_last() #Guarda el mapa.
tmap_save(test_map,"mapa.html",add.titles = TRUE) #Crea el archivo HTML del mapa dinámico.

