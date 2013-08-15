# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ = jQuery

$ ->
  
  $map = $("#map")
  
  if $map.length
    map = L.map('map').setView([48.856, 2.35], 13)
  
    cloudmade_api_key = $map.data("cloudmade-api-key")
    L.tileLayer("http://{s}.tile.cloudmade.com/#{cloudmade_api_key}/997/256/{z}/{x}/{y}.png", {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
        maxZoom: 18
    }).addTo(map)
    
    nodes = $map.data("nodes")
    nodes_by_id = $map.data("nodes-by-id")
    nodes_by_begin_at = $map.data("nodes-by-begin-at")
    characters = $map.data("characters")
    characters_by_id = $map.data("characters-by-id")
    for node in nodes
      lat = node.latitude
      lon = node.longitude
      title = node.title
      resume = node.resume
      topic_id = node.topic_id
      node_characters = []
      for ch_id in node.character_ids
        node_characters.push(characters_by_id[ch_id])
      with_ch = ""
      for ch in node_characters
        with_ch += ch.name + ' '
        
      marker = L.marker([lat, lon]).addTo(map)
      marker.bindPopup("<h5>#{title}</h5>#{resume}<br><small>#{with_ch}</small>")
    