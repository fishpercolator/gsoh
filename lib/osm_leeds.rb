require 'overpass_api_ruby'
require 'nokogiri'

class OSMLeeds
  BORDER = {n: 53.9458558, e: -1.2903452, s: 53.6983747, w: -1.8003617}
  
  def initialize
    @overpass = OverpassAPI.new(bbox: BORDER, json: true)
  end
  
  # Runs the given query on Overpass
  def query(hash)
    @overpass.query(query_xml hash)
  end
  
  private
  
  # Generates an XML query for the union of the given key-value pairs
  def query_xml(hash)
    Nokogiri::XML::Builder.new do |x|
      x.query(type: 'node') do
        hash.each do |k,v|
          x.send(:'has-kv', k: k, v: v)
        end
      end
    end.doc.root.to_s
  end
  
end
