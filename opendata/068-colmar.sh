## http://www.agglo-colmar.fr/geo

mkdir -p 068_colmar
cd 068_colmar
wget http://sig.agglo-colmar.fr/web/Sig/OpenData/FR-246800726-678/FR-246800726-678.zip
unzip FR-246800726-678.zip
ogr2ogr -t_srs EPSG:4326 -f PostgreSQL PG:dbname=cadastre FR_246800726_678.shp -overwrite -nlt GEOMETRY -nln import_colmar
psql cadastre -c "
BEGIN;
DELETE FROM cumul_adresses WHERE source='OD-COLMAR';
INSERT INTO cumul_adresses (
SELECT wkb_geometry, numero, voie, null, com_insee_||rivoli||cle_rivoli, com_insee_, null, '068', null, 'OD-COLMAR',null,null FROM import_colmar JOIN fantoir_voie on (fantoir=com_insee_||rivoli)
);
COMMIT;
"
