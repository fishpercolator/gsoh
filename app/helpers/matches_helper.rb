module MatchesHelper
  
  # Given an array of features, generate some JSON for rendering them on a map
  def features_map_json(features)
    features.map {|f| {latlng: [f.lat, f.lng], name: feature_name_and_subtype(f)} }.to_json
  end
  
  # Gets all the JSON needed to render a match as a polygon on the map
  def matches_map_json(matches)
    matches.map do |m|
      {
        polygon: m.area.polygon,
        name: m.area.name,
        score: m.score.to_i,
        path: match_path(area: m.area.name),
        color: matches.length > 1 ? '#' + colorgen.create_hex : '#000000'
      }
    end.to_json
  end
  
  private
  
  def colorgen
    @cg ||= ColorGenerator.new saturation: 0.5, lightness: 0.5
  end
  
end
