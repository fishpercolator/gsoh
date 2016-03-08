# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

render_area = (map, area) ->
  p = L.polygon(area["polygon"], color: area["color"]).addTo(map)
  p.bindPopup("<a href=\"#{area["path"]}\">#{area["name"]}</a> (#{area["score"]}% match)")

@initialize_matchmap = (map_data) ->
  matchmap = L.map('matchmap')
  osm = new L.TileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    minZoom: 10,
    maxZoom: 18,
    attribution: 'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'
  })
  matchmap.setView([53.794,-1.551], 11)
  matchmap.addLayer(osm)
  render_area(matchmap, area) for area in map_data
