# isybau2qgep

Instructions on using the (german specific) wastewater data format ["ISYBAU Austauschformate Abwasser (XML)"](http://www.arbeitshilfen-abwasser.de/html/A7ISYBAU_ATF_XML.html) in [QGIS](https://qgis.org) and the QGIS based waste-water application [QGEP](https://github.com/QGEP/QGEP).

Anleitung für die Verwendung der [ISYBAU Austauschformate Abwasser (XML)](http://www.arbeitshilfen-abwasser.de/html/A7ISYBAU_ATF_XML.html) in [QGIS](https://qgis.org) sowie in Verbindung mit der QGIS-basierten Abwasserfachschale [QGEP](https://github.com/QGEP/QGEP).

## Ziel A: Einfache Anzeige und Nutzung von ISYBAU XML in QGIS
* Verwendung des **[OGR Treibers GMLAS](http://www.gdal.org/drv_gmlas.html)** (GDAL >= 2.2) 
* bzw. der [GML Application Schema toolbox](http://planet.qgis.org/plugins/gml_application_schema_toolbox/)
1. [ISYBAU Schema](isybau2qgep/isybau_schema.md) referenzieren
2. einlesen: `ogrinfo`
3. importieren: `ogr2ogr`
4. mittels SQL
   1. Geometrien erzeugen und 
   2. Objekte ("Abwassertechnische Anlage" etc.) bilden

## Ziel B: Migration ins QGEP Schema
