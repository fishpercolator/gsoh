require 'overpass_api_ruby'
require 'nokogiri'

class OSMLeeds
  BORDER = {n: 53.9458558, e: -1.2903452, s: 53.6983747, w: -1.8003617}
  
  def initialize
    @overpass = OverpassAPI.new(bbox: BORDER, json: true)
  end
  
  # Runs the given query on Overpass
  def query(hash)
    # Array -> Hash so we can look up
    result = @overpass.query(query_xml hash).inject({}) {|h,v| h.update(v[:id] => v)}
    # Pull out all the child nodes into this hash
    result.each do |id, v|
      if v[:type] == 'way'
        v[:nodes] = v[:nodes].map {|id| result[id]}
      end
    end
    # Items without a name are probably just constituent nodes and we don't need them
    result.values.select {|v| v[:tags] && v[:tags][:name] }
  end
  
  private
  
  # Generates an XML query for the union of the given key-value pairs
  def query_xml(hash)
    Nokogiri::XML::Builder.new do |x|
      x.union do
        %w{node way}.each do |t|
          x.query(type: t) do
            hash.each do |k,v|
              options = {k: k}
              if v.is_a? String
                options[:v] = v
              end
              x.send(:'has-kv', options)
            end
          end
        end
        x.recurse(type: 'way-node') # include all nodes in a given way
      end
    end.doc.root.to_s
  end
  
end
