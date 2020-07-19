library(stringr)
as.factor(covid$sexo)
tablasex=table((covid$sexo))
sex=covid$sexo
tablasex[2]=tablasex[1]+tablasex[2]
tablasex=tablasex[-1]
tablasex[3]=tablasex[3]+tablasex[2]
tablasex=tablasex[-2]
lbls <- paste(names(tablasex), "\n", tablasex, sep="")
piesex=pie(tablasex, labels = lbls,
    main="Contagiados por sexo",col=rainbow(24))
as.factor(covid$fecha_diagnostico)
fecha=str_sub(covid$fecha_de_notificaci_n,6,7)
as.factor(fecha)
tablames=table(fecha)
names(tablames)=cbind("Marzo","Abril","Mayo","Junio")
labelss <- paste(names(tablames), "\n", tablames, sep="")
piemes=pie(tablames, labels = labelss,
    main="Contagiados por sexo",col=rainbow(24))


