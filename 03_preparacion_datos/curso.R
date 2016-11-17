lapply2  <- function(lista, funcion) {
  funcion(as.numeric(lista[1:length(lista)]))
}

lapply2(list(-1,2,-3), abs)

install.packages("sqldf", dependencies=TRUE)

install.packages("httr", dependencies=TRUE)


library(httr)


query.parms <- list(
  lat = 36.9003409,
  lon = -3.4244838
)
query.parms
# URL destindo
url <- "http://www.cartociudad.es/services/api/geocoder/reverseGeocode"

# Llamada al servicio y espera a respuesta
res <- GET(url, query = query.parms)
stop_for_status(res)

# Extracción del contenido, de JSON a lista
# Ver: http://www.cartociudad.es/services/api/geocoder/reverseGeocode?lat=36.9003409&lon=-3.4244838
info <- content(res)

info

# Más información de la respuesta
status_code(res)
headers(res)

# Un ejemplo con POST
url <- "http://httpbin.org/post"
body <- list(a = 1, b = 2, c = 3)

# Diferentes codificaciones
# Con verbose() vemos qué se manda exactamente al servidor
r <- POST(url, body = body, encode = "form", verbose())
r <- POST(url, body = body, encode = "multipart", verbose())
r <- POST(url, body = body, encode = "json", verbose())

# Ejercicio
# 1. Pregunta a la API de Nominatim de a dónde (calle, ciudad, ...)
#  pertenecen estas coordenadas: 51.4965946,-0.1436476


nominatin="http://nominatim.openstreetmap.org/reverse"
query.parms <- list(format="json", lat=51.4965946 , lon=-0.1436476)
res<-GET(nominatin, query = query.parms)
stop_for_status(res)
direccion<-content(res)

direccion
# 2. Pregunta a la API de la policía de UK por crímenes cometidos cerca
#  de esa localización en Julio de 2016
# 3. A partir de la respuesta, haz un conteo de los crímenes que ha habido
#  por categoría. Pista: puedes usar sapply y table
#

policia="https://data.police.uk/api/crimes-at-location"
query.parms <- list(date="2016-07", lat=51.4965946 , lng=-0.1436476)
res<-GET(policia, query = query.parms)
stop_for_status(res)
crimenes<-content(res)

crim<-as.data.frame(crimenes)


categorias <- sapply(crimenes, function(crimen) crimen$category )
table(categorias)

# Doc de las APIs
# http://wiki.openstreetmap.org/wiki/Nominatim#Reverse_Geocoding
# https://data.police.uk/docs/method/crimes-at-location/

#################
# Luz Frias
# 2016-10-25
# XML y HTML
# Basado en: http://yihui.name/en/2010/10/grabbing-tables-in-webpages-using-the-xml-package/
#################

install.packages("XML", dependencies = TRUE)
library(XML)

elecciones.url <- "http://resultados.elpais.com/resultats/eleccions/2016/generals/congreso/"
tablas <- readHTMLTable(elecciones.url, stringsAsFactors = FALSE)

tablas
resumen<-tablas[[2]]
names(resumen) <-resumen[1,]
resumen<-resumen[-1,]

# Ejercicio
# 1. ¿Qué le pasa a la cabecera de la tabla? ¿Por qué? Arréglalo
# 2. ¿Qué le pasa a los tipos de datos? ¿Por qué? Arréglalo. Pista: ?gsub
# 3. Pinta con plot el número de votos versus el número de escaños de los partidos
#  excluyendo a los 4 más votados


# Otra forma: con XPath
# referencia ejemplo: https://gist.github.com/izahn/5785265
# documentación XPath: http://ricostacruz.com/cheatsheets/xpath.html
library(RCurl)

## Descarga de RSS
xml.url <- "http://rss.cnn.com/rss/cnn_topstories.rss"
script <- getURL(xml.url, ssl.verifypeer = FALSE)

## Conversión a árbol XML
doc <- xmlParse(script)

## Extracción de información con XPath
titles <- xpathSApply(doc,'//item/title',xmlValue)
pubdates <- xpathSApply(doc,'//item/pubDate',xmlValue)
categories <- xpathSApply(doc,'//item/category',xmlValue)
links <- xpathSApply(doc,'//item/feedburner:origLink',xmlValue)
descriptions <- xpathSApply(doc,'//item/description',xmlValue)