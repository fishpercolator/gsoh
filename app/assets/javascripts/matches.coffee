# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

render_area = (map, area, single) ->
  opacity = if single then 0 else 0.2
  p = L.polygon(area["polygon"], color: area["color"], fillOpacity: opacity).addTo(map)
  if single
    # center the map on this polygon
    map.setView(p.getBounds().getCenter(), 14)
  else
    p.bindPopup("<a href=\"#{area["path"]}\">#{area["name"]}</a> (#{area["score"]}% match)")

@initialize_matchmap = (map_data, single = false) ->
  matchmap = L.map('matchmap')
  osm = new L.TileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    minZoom: 10,
    maxZoom: 18,
    attribution: 'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'
  })
  matchmap.addLayer(osm)
  render_area(matchmap, area, single) for area in map_data
  matchmap.setView([53.794,-1.551], 11) unless single
