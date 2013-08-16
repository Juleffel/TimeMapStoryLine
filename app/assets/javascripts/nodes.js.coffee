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
    characters_updated_at = $map.data("characters-updated-at")
    
    class CharacterList
      constructor: ->
        @characters = characters
        @construct_list()
        @nodes_by_id = nodes_by_id
        @updated_at = characters_updated_at
        setInterval( =>
          @update_from_server()
        3000)
      
      construct_list: ->
        @list = []
        for character in @characters
          @list.push(new Character(character))
      
      update_from_server: ->
        $.ajax
          type: "GET"
          url: "/nodes"
          dataType: "json"
          success: (data) =>
            @update(data.characters, data.nodes_by_id, data.characters_updated_at)
      update: (characters, nodes_by_id, characters_updated_at)->
        console.log('updated : ', @characters, characters)
        @characters = characters
        if characters_updated_at != @updated_at
          if characters.length == @list.length
            for new_ch, ind in characters
              old_ch = @list[ind].character
              if old_ch.id != new_ch.id
                @construct_list()
                break
              if old_ch.updated_at != new_ch.updated_at
                @list[ind].update_character(new_ch)
              else if old_ch.nodes_updated_at != new_ch.nodes_updated_at
                @list[ind].update_character_nodes(new_ch)
          else
            @construct_list()
    
    class Character
      constructor: (@character) ->
        @update_nodes()
        @create_node_obj()
        
      create_node_obj: ->
        console.log(@character.name, 'has nodes :', @nodes, 'and choose', @nodes[0].id)
        @node_obj = new Node(@nodes[0])
      destroy_node_obj: ->
        @node_obj.destroy()
        delete @node_obj
        
      update_character: (ch) ->
        @character = ch
        @update_characte_nodes(ch)
      update_character_nodes: (ch) ->
        @character = ch
        @update_nodes()
        @destroy_node_obj()
        @create_node_obj()
        alert("character #{ch.id} updated")
      update_nodes: ->
        @nodes = []
        for node_id in @character.node_ids
          @nodes.push(nodes_by_id[node_id])
        
      update_on_server: ->
        $.ajax
          type: "PUT"
          url: "/characters/"+@character.id
          data: 
            character: @character
          dataType: "json"
          success: =>
            console.log "Character #{@id} updated on server."
          error: =>
            alert "error on server !"
    
    class Node
      constructor: (@node) ->
        @update_characters()
        @marker = L.marker([@node.latitude, @node.longitude], {"draggable": true, "title": @character_names})
        #@marker.addTo(map)
        map.addLayer(@marker)
        @marker.on('dragend', (e) =>
          latlng = @marker.getLatLng()
          @node.latitude = latlng.lat
          @node.longitude = latlng.lng
          @update_on_server()
        )
        @update_popup()
      
      update_latlng: ->
        @marker.setLatLng([@node.latitude, @node.longitude])
        @marker.update()
      destroy_popup: ->
        @marker.closePopup()
        @marker.unbindPopup()
      update_popup: ->
        @destroy_popup()
        @marker.bindPopup "<h5>#{@title}</h5>#{@resume}<br><small>#{@character_names}</small>"
        
      destroy: ->
        console.log "destroying..."
        @destroy_popup()
        map.removeLayer(@marker)
        delete @marker
        
      update_characters: ->
        @characters = []
        for ch_id in @node.character_ids
          @characters.push(characters_by_id[ch_id])
        @character_names = ""
        for character in @characters
          @character_names += character.name + ' '
      
      update_on_server: ->
        $.ajax
          type: "PUT"
          url: "/nodes/"+@node.id
          data: 
            node: @node
          dataType: "json"
          success: =>
            console.log "Node #{@node.id} updated on server."
          error: =>
            alert "error on server !"
    
    character_list = new CharacterList
    #for node in nodes
    #  node_obj = new Node(node)
    