--Knoten: Bildung der Punktgeometrien, Achtung: nicht deckungsgleich mit Abwassertechnischen Anlagen, mehrer Punkte pro Anlage (SMP, DMP, etc.) möglich!
CREATE OR REPLACE VIEW isy_in.v_punktgeometrien AS 
 SELECT kp.ogc_fid, kp.ogr_pkid, kp.parent_ogr_pkid,
    kp.rechtswert, kp.hochwert, kp.punkthoehe,
    kp.punktattributabwasser,
    kp.lagegenauigkeitsstufe, kp.hoehengenauigkeitsstufe,
    ST_SetSRID(ST_MakePoint(kp.rechtswert, kp.hochwert), 4647)::geometry(Point,4647) AS p_geom_2d
   FROM isy_in.identi_datenk_stammd_abwassanlage_geomet_geomet_knoten_punkt kp;
