class City 
  include ActiveModel::Model
  
  attr_accessor :name
    
  # Regenerate all the OSM features for this city
  def regenerate_osm!  
    osm_ftypes.each do |ftype|
      Rails.logger.info("Regenerating #{ftype}:")
      ActiveRecord::Base.transaction do
        # FIXME: This will keep destroying and recreating, whereas really we want to update
        Feature.where(ftype: ftype).destroy_all
        osm_query.query_type(ftype).each {|osm| osm_to_feature(ftype, osm).save! }
      end
    end
  end
  
  # Regenerate all the CKAN features for this city
  def regenerate_ckan!
    metadata['ckan'].each do |url, features|
      CKAN::API.api_url = url
      features.each do |ftype, config|
        Rails.logger.info("Regenerating #{ftype}:")
        ActiveRecord::Base.transaction do
          Feature.where(ftype: ftype).destroy_all
          ckan_ftype(ftype, config)
        end
      end
    end
  end

  private
  
  # Get all the ftypes that will be queried from OSM
  def osm_ftypes
    metadata['osm'].keys.sort
  end
  
  # Returns an OSMQuery object for this city
  def osm_query
    @osm_query ||= OSMQuery.new(metadata['bounds'].symbolize_keys, metadata['osm'])
  end
  
  def metadata_files
    ["global", name].map {|f| Rails.root + 'config' + 'cities' + "#{f}.yml" }
  end
  
  # Memoized so it doesn't load every time
  def metadata
    @metadata ||= metadata_files.inject({}) do |metadata, file|
      metadata.update(YAML.load_file file)
    end
  end
  
  # Create a Feature object for a given osm item
  def osm_to_feature(ftype, osm)
    config = metadata['osm'][ftype]
    tags   = osm[:tags]
    Feature.new do |f|
      f.ftype = ftype
      f.name  = tags[:name]
      f.lat   = osm[:lat]
      f.lng   = osm[:lon]
      # If the city config mentions a subtype tag name, set that as subtype
      if config['subtype']
        f.subtype = tags[config['subtype'].to_sym]
      end
      # If there's a subtype_on_match hash, add the subtypes iff the queries
      # match
      if config['subtype_on_match']
        config['subtype_on_match'].each do |subtype, query|
          k, v = query.split('=')
          if tags[k.to_sym] == v
            f.subtype = subtype
          end
        end
      end
    end
  end
  
  # Create features for the given CKAN ftype
  def ckan_ftype(ftype, config)
    package = CKAN::Package.find(name: config['package']).first
    resource = if config['resource']
      package.resources.select {|r| r.description == config['resource']}.first
    else
      package.resources.first
    end
    cols = config['columns']
    # Currently only supports the first resource in each package (easily
    # changed when needed)
    csv_options = {headers: true}
    if config['encoding']
      csv_options[:encoding] = config['encoding']
    end
    data = resource.content_csv(csv_options)
    data.each do |row|
      ckan_row_to_feature(ftype, row, cols).save!
    end
  end
  
  def ckan_row_to_feature(ftype, row, cols)
    Feature.new do |f|
      f.ftype = ftype
      f.name  = row[cols['name']]
      # If it's using easting/northing, convert to lat/lng
      if cols.key? 'easting'
        latlng = Breasal::EastingNorthing.new({
          easting: row[cols['easting']].to_i,
          northing: row[cols['northing']].to_i
        }).to_wgs84
        f.lat = latlng[:latitude]
        f.lng = latlng[:longitude]
      else
        f.lat = row[cols['lat']]
        f.lng = row[cols['lng']]
      end
    end
  end
  
end
