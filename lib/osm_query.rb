require 'overpass_api_ruby'
require 'nokogiri'
require 'retriable'

class OSMQuery
  
  attr_reader :overpass, :types
  
  def initialize(border, types)
    @overpass = OverpassAPI.new(bbox: border, json: true)
    @types = types
  end
  
  # Given a type from all_types, run a query for all named nodes and ways
  def query_type(type)
    Retriable.retriable on: {JSON::ParserError => /rate_limited/}, base_interval: 3, tries: 5 do
      query(query_hash type)
    end
  end
  
  private
  
  # Get the query hash for the given type (if the type and tagname are the same,
  # retrieve all items with that tagname)
  def query_hash(type)
    tagname = types[type]['tag']
    if tagname == type
      {type => true}
    else
      {tagname => type}
    end
  end
  
  # Runs the given query on Overpass
  def query(hash)
    # Array -> Hash so we can look up
    result = overpass.query(query_xml hash).inject({}) {|h,v| h.update(v[:id] => v)}
    # Pull out all the child nodes into this hash
    result.each do |id, v|
      if v[:type] == 'way'
        v[:nodes] = v[:nodes].map {|id| result[id]}
        # Find something roughly in the middle and make that the lat/lon
        lats = v[:nodes].map {|n| n[:lat]}.compact
        lons = v[:nodes].map {|n| n[:lon]}.compact
        v[:lat] = (lats.max + lats.min)/2
        v[:lon] = (lons.max + lons.min)/2
      end
    end
    # Items without a name are probably just constituent nodes and we don't need them
    result.values.select {|v| v[:tags] && v[:tags][:name] }
  end
    
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
