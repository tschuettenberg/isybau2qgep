--Knoten: Bildung der Punktgeometrien, Achtung: nicht deckungsgleich mit Abwassertechnischen Anlagen, mehrer Punkte pro Anlage (SMP, DMP, etc.) möglich!
CREATE OR REPLACE VIEW sta_san_abn.v_objektgeometrien_p AS 
 SELECT kp.ogc_fid, kp.ogr_pkid, kp.parent_ogr_pkid,
    kp.rechtswert, kp.hochwert, kp.punkthoehe,
    kp.punktattributabwasser,
    kp.lagegenauigkeitsstufe, kp.hoehengenauigkeitsstufe,
    ST_SetSRID(ST_MakePoint(kp.rechtswert, kp.hochwert), 25832)::geometry(Point,25832) AS p_geom_2d
   FROM sta_san_abn.identi_datenk_stammd_abwassanlage_geomet_geomet_knoten_punkt kp;
