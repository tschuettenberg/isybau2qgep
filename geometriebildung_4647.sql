/* 
Geometriebildung aus ISYBAU Daten.
wegen Beispieldaten EPSG:4647 Achtung! achtstelliger Eastwert.
*/

-- Erstellung der Views in separaten Schema zum Schutz bei Import -overwrite
--CREATE SCHEMA isybau;

-- KNOTEN: Bildung der Punktgeometrien, Achtung: nicht deckungsgleich mit "Abwassertechnische Anlagen", mehrere Punkte pro Anlage (SMP, DMP, etc.) möglich!
CREATE OR REPLACE VIEW isybau.v_punktgeometrien AS 
 SELECT kp.ogc_fid,
    kp.ogr_pkid,
    kp.parent_ogr_pkid,
    kp.rechtswert,
    kp.hochwert,
    kp.punkthoehe,
    kp.punktattributabwasser,
    kp.lagegenauigkeitsstufe,
    kp.hoehengenauigkeitsstufe,
    st_setsrid(st_makepoint(kp.rechtswert, kp.hochwert), 4647)::geometry(Point,4647) AS p_geom_2d
   FROM isy_in.identi_datenk_stammd_abwassanlage_geomet_geomet_knoten_punkt kp;

-- KANTEN: Bildung der einfachen Liniengeometrien (Strecken)
CREATE OR REPLACE VIEW isybau.v_liniengeometrien AS 
 SELECT kk.parent_ogr_pkid,
    st_setsrid(st_makeline(st_makepoint(kk.start_rechtswert, kk.start_hochwert), st_makepoint(kk.ende_rechtswert, kk.ende_hochwert)), 4647)::geometry(LineString,4647) AS l_geom_2d
   FROM isy_in.identi_datenk_stammd_abwassanlage_geomet_geomet_kanten_kante kk
-- sowie der Polylinien aus mehreren Abschnitten
UNION ALL
 SELECT ( SELECT p_1.parent_ogr_pkid
           FROM isy_in.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p_1
          WHERE pk.parent_ogr_pkid::text = p_1.ogr_pkid::text) AS parent_ogr_pkid,
    st_setsrid(st_makeline(st_makeline(st_makepoint(pk.start_rechtswert, pk.start_hochwert), st_makepoint(pk.ende_rechtswert, pk.ende_hochwert))), 4647)::geometry(LineString,4647) AS l_geom_2d
   FROM isy_in.ident_daten_stamm_abwasanlag_geome_geome_polygo_polygo_kante pk,
    isy_in.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p
  WHERE pk.parent_ogr_pkid::text = p.ogr_pkid::text 
    AND p.polygonart = 3 -- V105: 3=Polylinie eines Objektes (offen)
  GROUP BY pk.parent_ogr_pkid;

-- KNOTEN: Bildung von Flächengeometrien
CREATE OR REPLACE VIEW isybau.v_flaechengeometrien AS 
 SELECT ( SELECT p_1.parent_ogr_pkid
           FROM isy_in.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p_1
          WHERE pk.parent_ogr_pkid::text = p_1.ogr_pkid::text) AS parent_ogr_pkid,
    st_setsrid(st_makepolygon(st_makeline(st_makeline(st_makepoint(pk.start_rechtswert, pk.start_hochwert), st_makepoint(pk.ende_rechtswert, pk.ende_hochwert)))), 4647)::geometry(Polygon,4647) AS f_geom_2d
   FROM isy_in.ident_daten_stamm_abwasanlag_geome_geome_polygo_polygo_kante pk,
    isy_in.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p
  WHERE pk.parent_ogr_pkid::text = p.ogr_pkid::text 
    AND (p.polygonart = ANY (ARRAY[1, 2])) -- V105: 1=innerer Polygonring eines Objektes (geschlossen), 2=äußerer Polyring eines Objektes (geschlossen)
  GROUP BY pk.parent_ogr_pkid;
