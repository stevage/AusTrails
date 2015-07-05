#createdb -T template_gis bins
DBNAME=trails
TABLE=alltrails
TABLEOPTIONS="-lco GEOMETRY_NAME=the_geom -lco FID=gid -nlt GEOMETRY"
function showcount() {
  t=$TABLE
  total=" in total."
  if [[ -n "$1" ]]; then
    t=$1
    total=""
  fi
  psql -d $DBNAME -c "select concat(count(*), ' $TABLE $total') from $t;" | grep "$TABLE"
}

date


psql -d $DBNAME -c "drop table rectrails"
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 recweb_track_raw/recweb_track.shp -append $TABLEOPTIONS -nln rectrails 2>&1 | grep -v '^ -->'


psql -d $DBNAME -c "drop table vicmap"
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 vicmap/tr_road.shp -append $TABLEOPTIONS -nln vicmap 2>&1 | grep -v '^ -->'


# Export bits from OSM to geojson
ogr2ogr -f GeoJSON osm/osm_cycling.json "PG:host=gis.researchmaps.net dbname=gis user=gis password=gis" -sql "select * from planet_osm_line where network in ('rcn', 'ncn')"
ogr2ogr -f GeoJSON osm/osm_hiking.json "PG:host=gis.researchmaps.net dbname=gis user=gis password=gis" -sql "select * from planet_osm_line where network in ('rwn','nwn')"
ogr2ogr -f GeoJSON osm/osm_mtb.json "PG:host=gis.researchmaps.net dbname=gis user=gis password=gis" -sql "select * from planet_osm_line where network = ('mtb')"

psql -d $DBNAME -c "drop table osm"
for file in osm/*.json; do
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 $file -append $TABLEOPTIONS -nln osm 2>&1 | grep -v '^ -->'
done

#pushd recweb_track
#for file in *.geojson; do
#echo "Loading $file"
#ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 $file -append $TABLEOPTIONS -nln rectrails 2>&1 | grep -v '^ -->'
#showcount rectrails
#done
#popd


psql -d $DBNAME -c "drop table greattrails"

for file in great_trails_victoria/converted/*.json; do
echo "Loading $file"
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 $file -append $TABLEOPTIONS -nln greattrails 2>&1 | grep -v '^ -->'
showcount greattrails
done
popd

psql -d $DBNAME -c "drop table ems_trails"
for file in ems/*.json; do
echo "Loading $file"
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 "$file" -append $TABLEOPTIONS -nlt MULTILINESTRING -lco DIM=2 -nln ems_trails 2>&1 | grep -v '^ -->'
#showcount greattrails_sites
done

# https://gist.githubusercontent.com/stevage/c4993d72218570e7cf7a/raw/map.geojson
psql -d $DBNAME -c "drop table wisdom"
psql -d $DBNAME -c "drop table wisdom_sites"

file=wisdom/map.geojson
echo "Loading $file"
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 "$file" -append $TABLEOPTIONS -skipfailures -nlt LINESTRING -lco DIM=2 -nln wisdom 2>&1 | grep -v '^ -->'
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 "$file" -append $TABLEOPTIONS -skipfailures -nlt POINT -lco DIM=2 -nln wisdom_sites 2>&1 | grep -v '^ -->'
#showcount greattrails_sites



psql -d $DBNAME -c "drop table recsites"
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 recreation_sites/recweb_site.shp -append $TABLEOPTIONS -nln recsites 2>&1 | grep -v '^ -->'


mkdir -p osm_sites
ogr2ogr -f GeoJSON osm_sites/camping.json "PG:host=gis.researchmaps.net dbname=gis user=gis password=gis" -sql "select * from planet_osm_point where tourism in ('camp_site', 'caravan_site')"
psql -d $DBNAME -c "drop table osm_sites"
for file in osm_sites/*.json; do
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 $file -append $TABLEOPTIONS -nln osm_sites 2>&1 | grep -v '^ -->'
done


psql -d $DBNAME -c "drop table greattrails_sites"
for file in great_trails_victoria/convertedwithoutsource/waypoints/*.json; do
echo "Loading $file"
ogr2ogr --config PG_USE_COPY YES -f "PostgreSQL" PG:"dbname=$DBNAME" -t_srs EPSG:3857 "$file" -append $TABLEOPTIONS -nln greattrails_sites 2>&1 | grep -v '^ -->'
#showcount greattrails_sites
done




#psql -d $DBNAME < mergetrails.sql
#showcount 
#psql -d $DBNAME < cleantrails.sql
#date

