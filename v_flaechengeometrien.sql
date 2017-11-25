--Knoten: Bildung von Flächengeometrien
CREATE OR REPLACE VIEW isy_in.v_objektgeometrien_f AS 
 SELECT ( SELECT p_1.parent_ogr_pkid
           FROM isy_in.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p_1
          WHERE pk.parent_ogr_pkid::text = p_1.ogr_pkid::text) AS parent_ogr_pkid,
    ST_SetSRID(ST_MakePolygon(ST_MakeLine(ST_MakeLine(ST_MakePoint(pk.start_rechtswert, pk.start_hochwert), ST_MakePoint(pk.ende_rechtswert, pk.ende_hochwert)))), 25832)::geometry(Polygon,25832) AS f_geom_2d
   FROM isy_in.ident_daten_stamm_abwasanlag_geome_geome_polygo_polygo_kante pk,
    isy_in.ident_daten_stammd_abwassanlage_geomet_geomet_polygo_polygon p
  WHERE pk.parent_ogr_pkid::text = p.ogr_pkid::text AND p.polygonart = 2
  GROUP BY pk.parent_ogr_pkid;
