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
    #nodes_by_begin_at = $map.data("nodes-by-begin-at")
    characters = $map.data("characters")
    characters_by_id = $map.data("characters-by-id")

    class Node
      constructor: (@id, @lat, @lng, @title, @resume, @topic_id, @character_ids) ->
        @update_characters()
        @marker = L.marker([lat, lng], {"draggable": true, "title": @character_names, "riseOnOver": true})
        @marker.addTo(map)
        $(@marker).bind('dragend', (e) =>
          latlng = @marker.getLatLng()
          @lat = latlng.lat
          @lng = latlng.lng
          @update_on_server()
        )
        @update_popup()
      
      update_latlng: ->
        @marker.setLatLng([@lat, @lng])
        @marker.update()
      update_popup: ->
        @marker.bindPopup "<h5>#{@title}</h5>#{@resume}<br><small>#{@character_names}</small>"
        
      update_characters: ->
        @characters = []
        for ch_id in @character_ids
          @characters.push(characters_by_id[ch_id])
        @character_names = ""
        for character in @characters
          @character_names += character.name + ' '
      
      update_on_server: ->
        $.ajax
          type: "PUT"
          url: "/nodes/"+@id
          data: 
            node:
              id: @id
              latitude: @lat
              longitude: @lng
              title: @title
              resume: @resume
              character_ids: @character_ids
          success: ->
            console.log "#{@id} updated on server."
          error: ->
            alert "error on server !"
          dataType: "json"
        
    
    for node in nodes
      node_obj = new Node(node.id, node.latitude, node.longitude, node.title, node.resume, node.topic_id, node.character_ids)
    