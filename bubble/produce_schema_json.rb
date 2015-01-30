require "rubygems"
require "json"
require "net/http"
require "uri"
require 'pp'



ROOT_URL="http://localhost:8983/solr/us_patent_grant"

uri = URI.parse(ROOT_URL + "/admin/luke?fl=*&wt=json&numTerms=0")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
 
response = http.request(request)

unless response.code == "200"
  raise "Boom"
end
result = JSON.parse(response.body)


distinct_data = {}
result["fields"].each do |key, value|
  distinct_data[key] = value["distinct"].nil? ? 1 : value["distinct"] 
end


pp distinct_data

uri = URI.parse(ROOT_URL + "/schema?wt=json")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
 
response = http.request(request)

bubble_data = {}
 
unless response.code == "200"
  raise "Boom"
end

result = JSON.parse(response.body)

result["schema"]["fields"].each do |field|
  if bubble_data[field["type"]].nil? then
   bubble_data[field["type"]] = []
  end
  field["fieldType"] = "field"
  bubble_data[field["type"]] << field
end

result["schema"]["dynamicFields"].each do |field|
  if bubble_data[field["type"]].nil? then
   bubble_data[field["type"]] = []
  end
  
  field["fieldType"] = "dynamicField"
  bubble_data[field["type"]] << field
end  


output_json = {:name => "us_patent_grant", :children => []}
bubble_data.each do |key,value|

  fields = value.select { |e| e["fieldType"] == "field" }
  dynamicFields = value.select { |e| e["fieldType"] == "dynamicField" }

  unless fields.empty?
    fieldHash = {}
    fieldHash["name"] = key
    fieldHash["children"] = []
    fields.each do |f|

      fieldHash["children"] << {:name => f["name"], :size => distinct_data[f["name"]]}
    end
    output_json[:children] << fieldHash
  end

  unless dynamicFields.empty?
    fieldHash = {}
    fieldHash["name"] = key
    fieldHash["children"] = []
    dynamicFields.each do |f|
      pp f
      fieldHash["children"] << {:name => f["name"], :size => distinct_data[f["name"]]}
    end
    output_json[:children] << fieldHash
  end
end

output = File.open( "us_patent_grant_schema2.json", "w" )
output << output_json.to_json
output.close