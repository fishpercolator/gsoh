module MatchesHelper
    
  # Gets all the JSON needed to render a match as a polygon on the map
  def matches_map_json(matches)
    matches.map do |m|
      {
        lat: m.area.lat,
        lng: m.area.lng,
        radius: Area::RADIUS,
        name: m.area.name,
        score: m.score.to_i,
        path: match_path(area: m.area.name),
        color: matches.length > 1 ? '#' + colorgen.create_hex : '#000000'
      }
    end.to_json
  end
  
  # Get JSON for a highlight
  def map_highlight(match)
    {
      lat: match.area.lat,
      lng: match.area.lng,
      radius: Area::RADIUS,
      color: '#000000'
    }.to_json
  end
  
  def show_features_on_map_button(features)
    ftype = features.first.ftype
    js = %{show_features("show-#{ftype}", #{features_map_json features})}
    button_tag 'Show', class: 'btn btn-default show-on-map', id: "show-#{ftype}", onclick: js
  end
  
  private
  
  # Given an array of features, generate some JSON for rendering them on a map
  def features_map_json(features)
    features.map {|f| {latlng: [f.lat, f.lng], name: feature_name_and_subtype(f)} }.to_json
  end
  
  def colorgen
    @cg ||= ColorGenerator.new saturation: 0.5, lightness: 0.5
  end
  
end
