CREATE OR REPLACE VIEW qgisybau.v_liniengeometrien2 AS
SELECT kk.parent_ogr_pkid, a.objektbezeichnung,
    st_setsrid(st_makeline(st_makepoint(kk.start_rechtswert, kk.start_hochwert), st_makepoint(kk.ende_rechtswert, kk.ende_hochwert)), 25832)::geometry(LineString,25832) AS l_geom_2d
   FROM isybau.identi_datenk_stammd_abwassanlage_geomet_geomet_kanten_kante kk
   join isybau.identifikati_datenkollekti_stammdatenkol_abwassertechnanlage a on kk.parent_ogr_pkid = a.ogr_pkid::text
UNION ALL
 SELECT ( SELECT p_1.parent_ogr_pkid
           FROM isybau.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p_1
          WHERE pk.parent_ogr_pkid::text = p_1.ogr_pkid::text) AS parent_ogr_pkid, a.objektbezeichnung,
    st_setsrid(st_makeline(st_makeline(st_makepoint(pk.start_rechtswert, pk.start_hochwert), st_makepoint(pk.ende_rechtswert, pk.ende_hochwert))), 25832)::geometry(LineString,25832) AS l_geom_2d
   FROM isybau.ident_daten_stamm_abwasanlag_geome_geome_polygo_polygo_kante pk,
    isybau.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p 
    join isybau.identifikati_datenkollekti_stammdatenkol_abwassertechnanlage a on p.parent_ogr_pkid = a.ogr_pkid::text
  WHERE pk.parent_ogr_pkid::text = p.ogr_pkid::text AND p.polygonart = 3
 GROUP BY pk.parent_ogr_pkid, objektbezeichnung;
