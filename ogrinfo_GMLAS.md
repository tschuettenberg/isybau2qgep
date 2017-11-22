# ISYBAU XML einlesen

mittels OGR Treiber GMLAS, Dokumentation: [http://www.gdal.org/drv_gmlas.html](http://www.gdal.org/drv_gmlas.html)  
und Open Option XSD, um auf das lokale [Schema](/1302_ISYBAU_XML_Schema/1302-metadaten.xsd) zu verweisen.

```
ogrinfo -ro GMLAS:C:\Users\giscoord\Downloads\isybau2qgep-master\1302_ISYBAU_XML_Beispieldaten\ISYBAU_XML-2013-Stammdaten_Sanierung_Abnahme.xml -oo XSD=C:\Users\giscoord\Downloads\isybau2qgep-master\1302_ISYBAU_XML_Schema\1302-metadaten.xsd
```
