/* 
Geometriebildung aus ISYBAU Daten.
EPSG:25832 ETRS89/UTM zone 32N
*/

-- Erstellung der Views in separaten Schema zum Schutz bei Import -overwrite
--CREATE SCHEMA qgisybau;

-- KNOTEN: Bildung der Punktgeometrien, Achtung: nicht deckungsgleich mit "Abwassertechnische Anlagen", mehrere Punkte pro Anlage (SMP, DMP, etc.) möglich!
CREATE OR REPLACE VIEW qgisybau.v_punktgeometrien AS 
 SELECT kp.ogc_fid,
    kp.ogr_pkid,
    kp.parent_ogr_pkid,
    kp.rechtswert,
    kp.hochwert,
    kp.punkthoehe,
    kp.punktattributabwasser,
    kp.lagegenauigkeitsstufe,
    kp.hoehengenauigkeitsstufe,
    st_setsrid(st_makepoint(kp.rechtswert, kp.hochwert), 25832)::geometry(Point,25832) AS p_geom_2d
   FROM isybau.identi_datenk_stammd_abwassanlage_geomet_geomet_knoten_punkt kp;

-- KANTEN: Bildung der einfachen Liniengeometrien (Strecken)
CREATE OR REPLACE VIEW qgisybau.v_liniengeometrien AS 
 SELECT kk.parent_ogr_pkid,
    st_setsrid(st_makeline(st_makepoint(kk.start_rechtswert, kk.start_hochwert), 
                           st_makepoint(kk.ende_rechtswert, kk.ende_hochwert)), 25832)::geometry(LineString,25832) AS l_geom_2d
   FROM isybau.identi_datenk_stammd_abwassanlage_geomet_geomet_kanten_kante kk
-- sowie der Polylinien aus mehreren Abschnitten
UNION ALL
 SELECT ( SELECT p_1.parent_ogr_pkid
           FROM isybau.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p_1
          WHERE pk.parent_ogr_pkid::text = p_1.ogr_pkid::text) AS parent_ogr_pkid,
    st_setsrid(st_makeline(st_makeline(st_makepoint(pk.start_rechtswert, pk.start_hochwert), 
                                       st_makepoint(pk.ende_rechtswert, pk.ende_hochwert))), 25832)::geometry(LineString,25832) AS l_geom_2d
   FROM isybau.ident_daten_stamm_abwasanlag_geome_geome_polygo_polygo_kante pk,
    isybau.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p
  WHERE pk.parent_ogr_pkid::text = p.ogr_pkid::text 
    AND p.polygonart = 3 -- V105: 3=Polylinie eines Objektes (offen)
  GROUP BY pk.parent_ogr_pkid;

-- KNOTEN: Bildung von Flächengeometrien
CREATE OR REPLACE VIEW qgisybau.v_flaechengeometrien AS 
 SELECT ( SELECT p_1.parent_ogr_pkid
           FROM isybau.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p_1
          WHERE pk.parent_ogr_pkid::text = p_1.ogr_pkid::text) AS parent_ogr_pkid,
    st_setsrid(st_makepolygon(st_makeline(st_makeline(st_makepoint(pk.start_rechtswert, pk.start_hochwert), 
                                                      st_makepoint(pk.ende_rechtswert, pk.ende_hochwert)))), 25832)::geometry(Polygon,25832) AS f_geom_2d
   FROM isybau.ident_daten_stamm_abwasanlag_geome_geome_polygo_polygo_kante pk,
    isybau.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p
  WHERE pk.parent_ogr_pkid::text = p.ogr_pkid::text 
    AND (p.polygonart = ANY (ARRAY[1, 2])) -- V105: 1=innerer Polygonring eines Objektes (geschlossen), 2=äußerer Polyring eines Objektes (geschlossen)
  GROUP BY pk.parent_ogr_pkid;
