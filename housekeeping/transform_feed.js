var fs = require('fs')
var underscore = require('underscore')
underscore.str = require('underscore.string')

var data_feed = JSON.parse( fs.readFileSync("./json/all.json") )
var zip_based_offenders_list = []

underscore.each(
    data_feed,
    function(el, idx, lst){
	for (zip in el) {
	    zip_based_offenders_list.push({
		zip: zip,
		offenders: el[zip]
	    })
	}
    }
),

fs.writeFile(
    "./json/zip_based_offenders_list.json",
    JSON.stringify(zip_based_offenders_list, null, 4),
    function(err){
    }
)
