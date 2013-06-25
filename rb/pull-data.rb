#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'nokogiri'
require 'json'

module FDLE

  def self.get_listing_for(zip_code)

    results_url = "http://offender.fdle.state.fl.us/offender/offenderSearchNav.do"
    results_uri = URI.parse(results_url)
    resp = Net::HTTP.get_response(results_uri)

    cookie = resp.response['set-cookie']
    post_params = {
      "firstName" => "",
      "includeAliases" => "on",
      "lastName" => "",
      "city" => "",
      "county" => "",
      "outOfFloridaCounty" => "",
      "zip" => zip_code,
      "offenderType" => "3",
      "lglStatus_1" => "1",
      "lglStatus_6" => "6",
      "lglStatus_7" => "7",
      "lglStatus_8" => "8",
      "lglStatus_9" => "9",
      "stateStatus" => "1",
      "includeThumbnail" => "on",
      "link" => "doSearch",
      "commaSeparatedOffenderStatus" => "1,6,7,8,9",
      "commaSeparatedPersonIds" => "",
      "commaSeparatedPersonIdsALL" => "",
      "totalResultsCount" => "",
      "page" => ""
    }
    
    zip_search_req = Net::HTTP::Post.new(results_uri.path)
    zip_search_req['Cookie'] = cookie
    zip_search_req['User-Agent'] = "WaterFox"
    zip_search_req['Referer'] = 'http://offender.fdle.state.fl.us/offender/offenderSearchNav.do'
    zip_search_req['Content-Type'] = 'application/x-www-form-urlencoded'

    listing = self.__recursively_get_listing_for_zipcode(
      zip_search_req, post_params, results_uri, []
    )
    return listing
  end

  def self.__recursively_get_listing_for_zipcode(zsr, args, uri, accum)
    
    zsr.set_form_data(args)
    zip_search_resp = Net::HTTP.start(uri.host) do |http|
      http.request(zsr)
    end
    
    dom_tree = Nokogiri::HTML(zip_search_resp.body)
    dom_tree.css('input[name="totalResultsCount"]').each { |elem|
      args["totalResultsCount"] = elem['value']
    }
    dom_tree.css('input[name="page"]').each { |elem|
      args["page"]  = elem['value'];
    }
    dom_tree.css('input[name="commaSeparatedPersonIdsALL"]').each { |elem|
      args["commaSeparatedPersonIdsALL"]  = elem['value'];
    }
    dom_tree.css('tr.ResultRow').each { |tr_elem|
      accum.push(
        tr_elem.css('td').each_with_index.select { |td_elem, idx|
          idx == 1 || idx == 2 || idx == 4
        }.map { |td_elem, idx|
          if idx == 1
            td_elem.css('img').first['src']
          elsif idx == 2
            td_elem.css('p:first').first.content.gsub(/\s+/, ' ').strip
          elsif idx == 4
            td_elem.css("br").each {|br| br.replace "," }
            td_elem.content.gsub(/Show Map/, '').gsub(/\s+/, ' ').strip.chop
          end
        }
      )
    }
    
    if args["page"].to_i*10 >= args["totalResultsCount"].to_i
      return accum
    else
      args["page"] = (args["page"].to_i + 1).to_s
      return self.__recursively_get_listing_for_zipcode(
        zsr, args, uri, accum
      )
    end
  end

  def self.get_picture_for(listing)
    img_id = listing[0].match(/imgID=(\d+)$/)[1]
    `wget http://offender.fdle.state.fl.us#{listing[0]} -O images/#{img_id}`
    return listing
  end

  def self.geoencode_address_for(listing)
    geocode_url = "http://maps.googleapis.com/maps/api/geocode/json"
    geocode_uri = URI.parse(geocode_url)
    geocode_uri.query = URI.encode_www_form({ :address => listing[2], :sensor => "false" })
    resp = Net::HTTP.get_response(geocode_uri)
    if resp.is_a?(Net::HTTPSuccess)
      geo_location = JSON.parse(resp.body)
      if geo_location["status"] == "OVER_QUERY_LIMIT"
        $stderr.puts geo_location.inspect
      end
      listing.push( geo_location["results"][0]["geometry"]["location"] )
    end
    return listing
  end

end

all_geoencoded_listings = []
all_marion_zip_codes_list = JSON.parse( IO.read("./json/marion_zip_codes_list.json") )
print "["
all_marion_zip_codes_list.each_with_index {
  |zip_code, idx|
  listings = FDLE.get_listing_for(zip_code)
  if idx > 0
    print ","
  end
  geoencoded_listings = listings.map {
    |listing|
    FDLE.get_picture_for(listing)
    FDLE.geoencode_address_for(listing)
  }
  print( { zip_code => geoencoded_listings }.to_json )
  #all_geoencoded_listings.push( { zip_code => geoencoded_listings } )
}
print "]" #puts( all_geoencoded_listings.to_json )
