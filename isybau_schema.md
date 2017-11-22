# ISYBAU Schema referenzieren

ISYBAU XML verfügt zwar über Schemas [Download: http://www.arbeitshilfen-abwasser.de/html/Materialien.1.32.html](http://www.arbeitshilfen-abwasser.de/html/Materialien.1.32.html), diese sind jedoch nicht online abrufbar, sondern nur lokal nutzbar.

## im XML Dokument
Damit das funktioniert, muss im einzulesenden XML-Dokumemt auf das Schema verwiesen werden[(vgl. https://www.w3schools.com/XML/schema_schema.asp](https://www.w3schools.com/XML/schema_schema.asp) und der Anfang des XML Dokumentes ergänzt werden:

```xml
<?xml version="1.0" encoding="iso-8859-1" standalone="yes"?>
<Identifikation xmlns="http://www.ofd-hannover.la/Identifikation"
           <!-- Ergänzung: -->
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                xsi:schemaLocation="http://www.ofd-hannover.la/Identifikation schema/1302-metadaten.xsd"> 
```

## als Treiberoption
Oder man spezifiziert die Schemadatei mit der GMLAS [Open Option](http://www.gdal.org/drv_gmlas.html#open_options) `XSD=filename`, wenn man den Treiber in OGR verwendet:

```
$ ogrinfo -ro GMLAS:[...]\ISYBAU_XML-2013-Stammdaten_Sanierung_Abnahme.xml -oo XSD=[...]\1302-metadaten.xsd
```

**Der Verweis auf das Schema des Metadaten-Bereiches `1302-metadaten.xsd` ist ausreichend, da in diesem alle weiteren Schema eingebunden werden.**
