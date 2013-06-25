var fs = require('fs');
var underscore = require('underscore');
underscore.str = require('underscore.string');

var marion_topojson = JSON.parse( fs.readFileSync("./json/marion_zipcodes_topo.json") );
var zip_codes = underscore.map(
    marion_topojson.objects.marion_zipcodes_geo.geometries,
    function(e){
	return [e.id, e.properties.name];
    }
);
fs.writeFile(
    "./json/marion_zip_codes_list.json",
    JSON.stringify(zip_codes, null, 4),
    function(err) {
	if(err){
	    console.log(err);
	} else {
	    console.log("Zip codes list saved to json file");
	}
    }
);
