drop table alltrails;
select 
wkb_geometry AS the_geom,
--ogc_fid AS id,
route_name AS name,
'OpenStreetMap' AS source,
'http://openstreetmap.org' AS sourceurl,
case when network in ('nwn','rwn') then 'yes' end as walking,
case when network in ('ncn','rcn','mtb') then 'yes' end as cycling,
'' AS description,
concat('OSM', osm_id) AS pid
INTO alltrails

from osm 
WHERE tags not ilike '%"state"=>"proposed"%' AND 
tags not ilike '%"state"=>"construction"%'
union

SELECT the_geom,
name AS name,
'DELWP Recreation Trails' AS source,
'https://www.data.vic.gov.au/data/dataset/recreation-track' AS sourceurl,
case when w_activity is not null then 'yes' end as walking ,
case when m_activity is not null then 'yes' end as cycling,
coalesce(m_comment,w_comment) AS description,
concat('DELWP', serial_no) AS pid

from rectrails
UNION
SELECT the_geom,
name AS name,
'The Great Trails Victoria' AS source,
'https://www.data.vic.gov.au/data/dataset?tags=Great+Trails+Victoria' AS sourceurl,
case when name ilike '%walk%' or name ilike '%Wilsons Prom%' or name ilike '%Alpine Trail' then 'yes' end as walking,
case when name ilike '%walk%' or name ilike '%Wilsons Prom%' or name ilike '%Alpine Trail' then null else 'yes' end as cycling,
'' AS description
FROM greattrails


UNION
SELECT wkb_geometry,
name AS name,
'Community-submitted cycling route' AS source,
'http://emscycletours.site44.com' AS sourceurl,
NULL as walking,
'yes' as cycling,
'' AS description
FROM ems_trails

UNION
SELECT wkb_geometry,
name AS name,
'Community-submitted cycling advice' AS source,
'https://gist.githubusercontent.com/stevage/c4993d72218570e7cf7a/raw/map.geojson' AS sourceurl,
NULL as walking,
'yes' as cycling,
description AS description
FROM wisdom

;

ALTER TABLE alltrails
ADD COLUMN id SERIAL;



DROP TABLE allsites;

select wkb_geometry AS the_geom,
'DELWP Recreation Sites' AS source,
name AS name,
CASE WHEN CAMPING='CAMPING' THEN 'yes' END as camping,
SITE_CLASS,
concat(comments, CAMPING_C, CARAVAN_C) AS description
INTO allsites

from recsites

union
select wkb_geometry AS the_geom,
'OpenStreetMap' as source,
name AS name,
CASE WHEN tourism in ('camp_site','caravan_site') THEN 'yes' END as camping ,
'' AS SITE_CLASS,
'' AS description
from osm_sites
union
SELECT wkb_geometry AS the_geom,
'The Great Trails Victoria' AS source,
name AS name,
-- note the case sensitivity - trying to avoid false hits on "no camping"
CASE WHEN description like '%Camp%' OR description ilike '%campground%' THEN 'yes' END AS camping,
'' AS SITE_CLASS,
description AS description
FROM greattrails_sites;

ALTER TABLE allsites 
ADD COLUMN  id SERIAL;



-- http://austrails.org/datasources/greattrails_images/
ALTER TABLE alltrails
ADD COLUMN photo character varying (100);
update alltrails set photo='great-south-west-walk/thumb_19435_trail_gallery.jpeg' where name='Great South West Walk';
update alltrails set photo='great-ocean-walk/thumb_19428_trail_gallery.jpeg' where name ilike 'Great Ocean Walk%';
update alltrails set photo='east-gippsland-rail-trail/thumb_54968_trail_gallery.jpeg' where source like '%Great Trails%' and name ilike 'East Gippsland Rail Trail%';
update alltrails set photo='wilsons-promontory-southern-circuit/thumb_19433_trail_gallery.jpeg' where source like '%Great Trails%' and name ilike 'Wilsons Prom%%';
update alltrails set photo='mornington-peninsula-walk/thumb_19411_trail_gallery.jpeg' where source like '%Great Trails%' and name ilike 'Mornington%';
update alltrails set photo='goldfields-track/thumb_54970_trail_gallery.jpeg' where source like '%Great Trails%' and name ilike 'Goldfields%';
update alltrails set photo='surf-coast-walk/thumb_19430_trail_gallery.jpeg' where source like '%Great Trails%' and name ilike 'Surf Coast%';
update alltrails set photo='lilydale-to-warburton-rail-trail/thumb_19409_trail_gallery.jpeg' where source like '%Great Trails%' and name ilike 'Lilydale%';


ALTER TABLE alltrails
ADD COLUMN pid character varying (100);
update alltrails set pid=concat(regexp_replace(name, '\W+', '', 'g'), id);

ALTER TABLE allsites
ADD COLUMN pid character varying (100);
update allsites set pid=concat(regexp_replace(name, '\W+', '', 'g'), id);



surf-coast-walk/thumb_19430_trail_gallery.jpeg

great-ocean-walk/thumb_19428_trail_gallery.jpeg
great-ocean-walk/thumb_19427_trail_gallery.jpeg
great-ocean-walk/thumb_19429_trail_gallery.jpeg
east-gippsland-rail-trail/thumb_54968_trail_gallery.jpeg
lilydale-to-warburton-rail-trail/thumb_19409_trail_gallery.jpeg
wilsons-promontory-southern-circuit/thumb_19433_trail_gallery.jpeg
wilsons-promontory-southern-circuit/thumb_19434_trail_gallery.jpeg
mornington-peninsula-walk/thumb_19411_trail_gallery.jpeg
mt-buller-bike-park/thumb_19416_trail_gallery.jpeg
mt-buller-bike-park/thumb_19418_trail_gallery.jpeg
mt-buller-bike-park/thumb_19417_trail_gallery.jpeg
great-south-west-walk/thumb_19435_trail_gallery.jpeg
great-south-west-walk/thumb_19436_trail_gallery.jpeg
goldfields-track/thumb_54970_trail_gallery.jpeg
surf-coast-walk/thumb_19430_trail_gallery.jpeg
you-yangs-mountain-bike-park/thumb_19431_trail_gallery.jpeg
great-walhalla-alpine-trail/thumb_19426_trail_gallery.jpeg
gippsland-plains-rail-trail/thumb_19420_trail_gallery.jpeg