# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

render_area = (area, single) ->
  opacity = if single then 0 else 0.2
  p = L.polygon(area["polygon"], color: area["color"], fillOpacity: opacity).addTo(@matchmap)
  if single
    # center the map on this polygon
    @matchmap.setView(p.getBounds().getCenter(), 14)
  else
    p.bindPopup("<a href=\"#{area["path"]}\">#{area["name"]}</a> (#{area["score"]}% match)")

@initialize_matchmap = (map_data, single = false) ->
  @matchmap = L.map('matchmap')
  osm = new L.TileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    minZoom: 10,
    maxZoom: 18,
    attribution: 'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'
  })
  @matchmap.addLayer(osm)
  render_area(area, single) for area in map_data
  @matchmap.setView([53.794,-1.551], 11) unless single

show_feature = (feature) ->
  marker = L.marker(feature["latlng"]).addTo(@matchmap)
  marker.bindPopup(feature["name"])
  @showing_features.push marker

@show_features = (id, features) ->
  # Remove all existing markers
  if @showing_features?
    @matchmap.removeLayer(layer) for layer in @showing_features
  @showing_features = []
  # Set all the buttons to grey
  $('button.show-on-map').removeClass('btn-success')
  $("##{id}").addClass('btn-success')
  show_feature(feature) for feature in features
  