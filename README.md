== A d3.js Visualization of distribution of Sexual Offenders/Predators in Marion County, FL.

= Structure:

 .
 |-- bootstrap
 |   |-- css
 |   |   |-- bootstrap.css
 |   |   |-- bootstrap.min.css
 |   |   |-- bootstrap-responsive.css
 |   |   `-- bootstrap-responsive.min.css
 |   |-- img
 |   |   |-- glyphicons-halflings.png
 |   |   `-- glyphicons-halflings-white.png
 |   `-- js
 |       |-- bootstrap.js
 |       `-- bootstrap.min.js
 |-- css
 |   |-- overrides.css
 |-- csv
 |-- gis
 |   `-- marion_local_data
 |       |-- marion_zipcodes.dbf
 |       |-- marion_zipcodes_geo.json
 |       |-- marion_zipcodes.prj
 |       |-- marion_zipcodes.qpj
 |       |-- marion_zipcodes.shp
 |       |-- marion_zipcodes.shx
 |       |-- marion_zipcodes_topo.json
 |       |-- ZipcodeBoundaries.dbf
 |       |-- ZipcodeBoundaries_geo.json
 |       |-- ZipcodeBoundaries.prj
 |       |-- ZipcodeBoundaries.sbn
 |       |-- ZipcodeBoundaries.sbx
 |       |-- ZipcodeBoundaries.shp
 |       |-- ZipcodeBoundaries.shp.xml
 |       |-- ZipcodeBoundaries.shx
 |       `-- ZipcodeBoundaries_topo.json
 |-- housekeeping
 |   |-- get_zipcodes.js
 |   |-- transform_feed.js
 |-- images
 |-- index.html
 |-- js
 |   |-- backbone-min.js
 |   |-- d3.v3.min.js
 |   |-- jquery.min.js
 |   |-- marion-fl-usa.js
 |   |-- quineloop_utils.js
 |   |-- topojson.v1.min.js
 |   |-- underscore-min.js
 |   `-- underscore.string.min.js
 |-- json
 |   |-- all.json
 |   |-- all.old.json
 |   |-- marion_zip_codes_list.json
 |   |-- marion_zipcodes_topo.json
 |   `-- zip_based_offenders_list.json
 |-- rb
 |   |-- pull-data.rb
 |-- README.md

 13 directories, 879 files

= Summary:

* The Directory GIS contains the shapefile that can be viewed/edited using qgis
* The shapefile is converted to geojson => topojson using the commands `ogr2ogr` and `topojson`

* Data for the visualization is obtained from website of "Florida Dept of Law Enforcement" - http://offender.fdle.state.fl.us/offender/homepage.do 
* images/ is the directory into which the images are downloaded from http://offender.fdle.state.fl.us
* The ruby script rb/pull-data.rb gets the data for each zip code that is part of Marion County
* The JS scripts in housekeeping/*.js are used to transform json data when required
