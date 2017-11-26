--Kanten: Bildung der einfachen Liniengeometrien (Strecken)
CREATE OR REPLACE VIEW isy_in.v_liniengeometrien AS 
 SELECT kk.parent_ogr_pkid,
    ST_SetSRID(ST_MakeLine(ST_MakePoint(kk.start_rechtswert, kk.start_hochwert), ST_MakePoint(kk.ende_rechtswert, kk.ende_hochwert)), 4647)::geometry(LineString,4647) AS l_geom_2d
   FROM isy_in.identi_datenk_stammd_abwassanlage_geomet_geomet_kanten_kante kk
UNION ALL
--sowie der Polylinien aus mehreren Abschnitten
 SELECT ( SELECT p_1.parent_ogr_pkid
           FROM isy_in.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p_1
          WHERE pk.parent_ogr_pkid::text = p_1.ogr_pkid::text) AS parent_ogr_pkid,
    ST_SetSRID(ST_MakeLine(ST_MakeLine(ST_MakePoint(pk.start_rechtswert, pk.start_hochwert), ST_MakePoint(pk.ende_rechtswert, pk.ende_hochwert))), 4647 )::geometry(LineString,4647) AS l_geom_2d
   FROM isy_in.ident_daten_stamm_abwasanlag_geome_geome_polygo_polygo_kante pk,
    isy_in.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p
  WHERE pk.parent_ogr_pkid::text = p.ogr_pkid::text AND p.polygonart = 3
  GROUP BY pk.parent_ogr_pkid;
