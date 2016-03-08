module MatchesHelper
  
  # Given an array of features, generate some JSON for rendering them on a map
  def features_map_json(features)
    features.map {|f| {latlng: [f.lat, f.lng], name: f.name} }.to_json
  end
  
end
