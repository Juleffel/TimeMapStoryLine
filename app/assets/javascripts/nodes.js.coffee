# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ = jQuery

$ ->
  
  $map = $("#map")
  
  if $map.length
    map = L.map('map').setView([20, 50], 2)
  
    cloudmade_api_key = $map.data("cloudmade-api-key")
    L.Icon.Default.imagePath = "http://leafletjs.com/dist/images"
    L.tileLayer("http://{s}.tile.cloudmade.com/#{cloudmade_api_key}/997/256/{z}/{x}/{y}.png", {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
        maxZoom: 18
    }).addTo(map)
    
    # smallPointIcon
    # middlePointIcon
    smallPointIcon = L.icon
      iconUrl: 'http://upload.wikimedia.org/wikipedia/commons/d/d7/Red_Point.gif',
      iconSize: [10, 10],
      iconAnchor: [5, 5],
      popupAnchor: [0, -5],
    mediumPointIcon = L.icon
      iconUrl: 'http://upload.wikimedia.org/wikipedia/commons/d/d7/Red_Point.gif',
      iconSize: [20, 20],
      iconAnchor: [10, 10],
      popupAnchor: [0, -10],
    bigPointIcon = L.icon
      iconUrl: 'http://upload.wikimedia.org/wikipedia/commons/d/d7/Red_Point.gif',
      iconSize: [30, 30],
      iconAnchor: [15, 15],
      popupAnchor: [0, -15],
      #shadowUrl: 'my-icon-shadow.png',
      #shadowRetinaUrl: 'my-icon-shadow@2x.png',
      #shadowSize: [68, 95],
      #shadowAnchor: [22, 94]
    
    # Some content from $map data
    nodes = $map.data("nodes")
    nodes_by_id = $map.data("nodes-by-id")
    #nodes_by_begin_at = $map.data("nodes-by-begin-at")
    characters = $map.data("characters")
    characters_by_id = $map.data("characters-by-id")
    characters_updated_at = $map.data("characters-updated-at")
    
    # Small functions for dates
    j_date = (str_date)->
      new Date(Date.parse(str_date))
    jv_date = (str_date)->
      j_date(str_date).valueOf()
    json_data = ($block, attr) ->
      JSON.parse($block.data(attr))
    blank = (str)->
      (!str? || (str.length == 0))
    
    # Class for stock and update automitically the character list and their nodes
    # @characters: models from the db
    # @list: list of Character objects
    # @updated_at: store the value of @characters_updated_at at each fetch from the db
    # @last_date: store the value of the date of the slider
    class CharacterList
      constructor: ->
        @characters = characters
        @construct_list()
        @updated_at = characters_updated_at
        setInterval( =>
          @update_from_server()
        3000)
      
      # Destroy and recreate the list of the characters objects
      construct_list: ->
        @list = []
        for character in @characters
          @list.push(new Character(character))
      
      # Fetch characters and nodes from server
      update_from_server: ->
        $.ajax
          type: "GET"
          url: "/nodes"
          dataType: "json"
          success: (data) =>
            nodes_by_id = data.nodes_by_id
            @update(data.characters, data.characters_updated_at)
      # Update only the characters that have been changed since the last fetch
      update: (characters, characters_updated_at)->
        @characters = characters
        if characters_updated_at != @updated_at
          # A character has changed
          if characters.length == @list.length
            for new_ch, ind in characters
              old_ch = @list[ind].character
              if old_ch.id != new_ch.id
                # Not the same character at the same position as before
                @construct_list()
                break
              if old_ch.updated_at != new_ch.updated_at
                # Character updated
                @list[ind].update_character(new_ch)
              else if old_ch.nodes_updated_at != new_ch.nodes_updated_at
                # Character_node updated
                @list[ind].update_character_nodes(new_ch)
          else
            # not the same number of characters as before
            @construct_list()
      # Updates the date for all the characters of the map
      update_date: (new_date)->
        if new_date != @last_date
          @last_date = new_date
          if !@date_blocked
            # One modif max for 500 ms
            @date_blocked = true
            setTimeout( =>
              @date_blocked = false
              # Ensure that the last date set is the one on the slider
              setTimeout( =>
                if !@date_blocked && @last_date != new_date
                  @update_date(@last_date)
              10)
            15)
            for c in @list
              c.update_date(new_date)
    
    # A character is the character and its nodes
    # @character: Character model from server
    # @nodes: Array of nodes model from server
    # @date: date of the map, this character print his marker according to this date
    # @node: Fake node model with properties calculate by @date
    # @node_obj: class Node object corresponding to the marker, calculate and updated according to @node
    class Character
      # Create the character
      # He has'nt date, so he has'nt node_obj at the beginning
      constructor: (@character) ->
        @update_nodes()
        
      # Update content and position of @node and @node_obj
      # @node_obj must exists
      change_node: ->
        @update_node_obj_position()
        @last_node_index = @next_node_index
      # Update position of @node and @node_obj
      # @node_obj must exists
      update_node_obj_position: ->
        @node = $.extend({}, @nodes[@next_node_index])
        suiv_node = @nodes[@next_node_index+1]
        cur_node = @nodes[@next_node_index]
        cur_lat = cur_node.latitude
        cur_lng = cur_node.longitude
        @node.real = false
        if !suiv_node || j_date(cur_node.end_at) >= @date
          if j_date(cur_node.begin_at) <= @date && j_date(cur_node.end_at) >= @date
            @node.real = true
          new_lat = cur_lat
          new_lng = cur_lng
        else
          # We are between two nodes
          diff_lat = suiv_node.latitude - cur_lat
          diff_lng = suiv_node.longitude - cur_lng
          diff_dates = jv_date(suiv_node.begin_at) - jv_date(cur_node.end_at)
          diff_dates_current = jv_date(@date) - jv_date(cur_node.end_at)
          if diff_dates == 0
            # Nodes times are touching each other
            # Whoops ! Warning: Div by 0 !
            new_lat = cur_lat
            new_lng = cur_lng
          else
            new_lat = cur_lat + diff_lat * (diff_dates_current/diff_dates)
            new_lng = cur_lng + diff_lng * (diff_dates_current/diff_dates)
          #console.log("char:", @character.name)
          #console.log('latlng:', cur_lat, cur_lng, new_lat, new_lng)
          #console.log('diffs:', diff_lat, diff_lng, diff_dates, diff_dates_current)
        @node.latitude = new_lat
        @node.longitude = new_lng
        @node_obj.update_node(@node)
      # Update @node to correspond with the date and update or recreate 
      update_node_obj: ->
        @choose_node()
        if @next_node_index != -1
          if @last_node_index != @next_node_index
            if @node_obj
              @change_node()
            else
              @create_node_obj()
          else
            @update_node_obj_position()
        else
          @destroy_node_obj()
          
      # Update @next_node_index with the index of the node just before the date,
      # or the first node if the date is before
      choose_node: ->
        if @date && @nodes.length > 0
          node_index = 0
          # Functions
          search_forward = =>
            while @nodes[node_index+1] && (j_date(@nodes[node_index+1].begin_at) <= @date)
              node_index += 1
          search_backward = =>
            while @nodes[node_index-1] && (j_date(@nodes[node_index-1].begin_at) > @date)
              node_index -= 1
            if @nodes[node_index-1]
              node_index -= 1
          # Core
          if @last_node_index == -1
            search_forward()
          else
            node_index = @last_node_index
            if (j_date(@nodes[node_index].begin_at) < @date)
              search_forward()
            else
              search_backward()
          @next_node_index = node_index
        else
          @next_node_index = -1
        
      # Read @next_node_index and create a @node_obj
      create_node_obj: ->
        if @next_node_index != -1
          @node = $.extend({}, @nodes[@next_node_index])
          if j_date(@node.begin_at) <= @date && j_date(@node.end_at) >= @date
            @node.real = true
          else
            @node.real = false
          @node_obj = new Node(@node)
        @last_node_index = @next_node_index
      # Delete the @node_obj
      destroy_node_obj: ->
        if @node_obj
          @node_obj.destroy()
          delete @node_obj
        
      # Change the date of the character ->
      # it updates his node with this date
      update_date: (new_date) ->
        @date = new_date
        @update_node_obj()
      # Updates all the properties of a character, even his descriptions and nodes
      update_character: (ch) ->
        @character = ch
        @update_characte_nodes(ch)
      # Refetch nodes, remove node_obj and recreate it
      update_character_nodes: (ch) ->
        @character = ch
        @update_nodes()
        @update_node_obj()
      # Take @character.node_ids and fetch nodes from nodes_by_id
      update_nodes: ->
        @last_node_index = -1
        @next_node_index = -1
        @nodes = []
        for node_id in @character.node_ids
          @nodes.push(nodes_by_id[node_id])
        
      # Update the character on the server
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
    
    # Class corresponding to a Marker on the map
    # @node: node model from the server. If @node.real is true, @node correspond truly to a model in the db,
    #   else, it's a fake node
    # @marker: marker on the map, class from Leaflet
    # @characters: characters models fetch by ids in @node.character_ids
    # @character_names: Property calculated from @characters
    class Node
      # Create a marker on the map
      constructor: (@node) ->
        @update_characters()
        @marker = L.marker([@node.latitude, @node.longitude], {"draggable": true, "title": @character_names})
        #@marker.addTo(map)
        map.addLayer(@marker)
        @resize_marker()
        @marker.on('dragend', (e) =>
          latlng = @marker.getLatLng()
          @node.latitude = latlng.lat
          @node.longitude = latlng.lng
          if @node.real
            @update_on_server()
          else
            delete @node.id
            @node.title = prompt("Titre")
            @node.resume = prompt("Résumé")
            delete @node.topic_id
            @node.begin_at = character_list.last_date
            delete @node.end_at
            @create_on_server()
            #@destroy()
        )
        @popup = false
        @update_popup()
        #console.log @node, "created"
      
      # Updates the position of the marker on the map
      update_latlng: ->
        @marker.setLatLng([@node.latitude, @node.longitude])
        
      # Update whole content of node (popup, position..) according to the content of node
      update_node: (node) ->
        #console.log("Update node content", @node.title, "->", node.title)
        if @node.real == node.real && @node.id == node.id
          @node = node
          @update_latlng()
        else
          console.log(@node.id, "->", node.id)
          @node = node
          @update_characters() if @node.real
          @resize_marker()
          @update_popup()
          @update_latlng()
          
      popup_content: ->
        if @node.real
          str = ""
          str += "<h4>#{@node.title}</h4>" if !blank(@node.title)
          str += "<p>#{@node.resume}</p>" if !blank(@node.resume)
          str += "<small>#{@character_names}</small>" if !blank(@character_names)
        else
          null
        
      resize_marker: ->
        if @node.real && @node.title && @node.title.length > 0
          if @node.topic_id
            @marker.setIcon(bigPointIcon)
          else
            @marker.setIcon(mediumPointIcon)
        else
          @marker.setIcon(smallPointIcon)
      
      destroy_popup: ->
        @marker.closePopup()
        @marker.unbindPopup()
        @popup = false
      # Update the popup
      update_popup: ->
        cont = @popup_content()
        if cont?
          if @popup
            @marker.setPopupContent cont
          else
            console.log("create popup", cont)
            @marker.bindPopup cont
            @popup = true
        else
          @destroy_popup()
        
      # Destroy popup and marker
      destroy: ->
        console.log "destroying..."
        @destroy_popup()
        map.removeLayer(@marker)
        delete @marker
        
      # Fetch characters model by @node.character_ids
      # Calculate @character_names
      update_characters: ->
        @characters = []
        for ch_id in @node.character_ids
          @characters.push(characters_by_id[ch_id])
        @character_names = ""
        for character in @characters
          @character_names += character.name + ' '
      
      # Update @node on server
      update_on_server: ->
        alert("update a non real node !") unless @node.id != 0
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
      # Create @node on server
      create_on_server: ->
        #alert('create on server !')
        $.ajax
          type: "POST"
          url: "/nodes/"
          data: 
            node: @node
          dataType: "json"
          success: =>
            console.log "Node #{@node.id} created on server."
          error: =>
            alert "error on server !"
    
    character_list = new CharacterList
    #for node in nodes
    #  node_obj = new Node(node)
    
    $date_slider = $("#date-slider")
    $date_value = $("#date-value")
    from = j_date(json_data($date_slider, "from"))
    to = j_date(json_data($date_slider, "to"))
    hour_in_ms = 1000*60*60
    day_in_ms = hour_in_ms*24
    
    # Modif the sample to precise the time
    sample = hour_in_ms
    
    duration = (to-from)/sample
    
    update_date = (date)->
      $date_value.text(date.toLocaleString())
      character_list.update_date(date)
    update_date(to)
    $date_slider.slider
      min: 0
      max: duration
      value: duration
      slide: (event, ui) ->
        new_date = new Date(from.valueOf()+ui.value*sample)
        update_date(new_date)
    