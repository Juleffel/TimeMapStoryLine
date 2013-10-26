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
    
    # TODO : choose your character
    main_character = characters[0]
    
    ###################
    # UTILS
    ###################
    # Small functions for dates
    j_date = (str_date)->
      new Date(Date.parse(str_date))
    jv_date = (str_date)->
      j_date(str_date).valueOf()
    json_data = ($block, attr) ->
      JSON.parse($block.data(attr))
    blank = (str)->
      (!str? || (str.length == 0))
    
    ###############################
    # Class for stock and update automitically the character list and their nodes
    # @characters: models from the db
    # @list: list of Character objects
    # @updated_at: store the value of @characters_updated_at at each fetch from the db
    # @last_date: store the value of the date of the slider
    ###############################
    class CharacterList
      constructor: ->
        # characters and characters_updated_at are data sent with the page in $map
        @characters = characters
        @construct_list()
        @updated_at = characters_updated_at
        # Refresh data by AJAX every 3 seconds # TODO Adjust
        setInterval( =>
          @update_from_server()
        1000)
      
      # Destroy and recreate the list of the characters objects
      construct_list: ->
        @list = []
        for character in @characters
          @list.push(new Character(character))
        last_date = @last_date         
        if last_date
          @last_date = null
          update_date(last_date)
      
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
          @updated_at = characters_updated_at
          console.log "chars updated"
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
                console.log "ch", new_ch, "updated"
                @list[ind].update_character(new_ch)
              else if old_ch.nodes_updated_at != new_ch.nodes_updated_at
                # Character_node updated
                console.log "ch nodes", new_ch, "updated"
                @list[ind].update_character_nodes(new_ch)
          else
            # not the same number of characters as before
            @construct_list()
      # Updates the date for all the characters of the map
      update_date: (new_date)->
        if new_date != @last_date
          @last_date = new_date
          if !@date_blocked
            # One modif max for 15 ms
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
    
    ###############################
    # A character is the character and its nodes
    # @character: Character model from server
    # @nodes: Array of nodes model from server
    # @date: date of the map, this character print his marker according to this date
    # @node: Fake node model with properties calculate by @date
    # @node_obj: class Node object corresponding to the marker, calculate and updated according to @node
    ###############################
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
          else
            @node.id = undefined
          new_lat = cur_lat
          new_lng = cur_lng
        else
          @node.id = undefined
          # We are between two nodes
          diff_lat = suiv_node.latitude - cur_lat
          diff_lng = suiv_node.longitude - cur_lng
          diff_dates = jv_date(suiv_node.begin_at) - jv_date(cur_node.end_at)
          diff_dates_current = jv_date(@date) - jv_date(cur_node.end_at)
          if diff_dates == 0
            # Nodes times are touching each other (Teleportation)
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
              # node has changed
              @change_node()
            else
              # first time
              @create_node_obj()
          else
            # Same node as before
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
          # Copy the node in a new object
          @node = $.extend({}, @nodes[@next_node_index])
          if j_date(@node.begin_at) <= @date && j_date(@node.end_at) >= @date
            # Date is between nood.begin_at and node.end_at
            @node.real = true
          else
            @node.real = false
            @node.id = undefined
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
      # WARNING : For the moment, do exactly the same than the next function.
      # Reflection needed.
      update_character: (ch) ->
        @character = ch
        @update_character_nodes(ch)
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
            alert "Error on server ! Character #{@id} update failed."
    
    ###########################
    # Structure to gathering node_objs
    ###########################
    class NodeCollection # Not RockCollection, man
      constructor: () ->
        # Initiate the hash table
        @node_objs_by_id = {}
        @node_objs = []
      
      # [ Called by node_obj creation, node_obj maj
      register: (node_obj)-> 
        @node_objs.push(node_obj)
        id = node_obj.node.id
        if id
          @node_objs_by_id[id] = node_obj
        
      # [ Called by node_obj_maj, node_obj_destruction
      remove: (node_obj) ->
        id = node_obj.node.id
        if id
          @node_objs_by_id[id] = null
          delete @node_objs_by_id[id]
        # Remove node_obj from @node_objs
        index = -1
        for nd_obj, ind in @node_objs
          if nd_obj == node_obj
            index = ind
        if (index > -1)
          @node_objs.splice(index, 1)
        
      # [ Called before register
      fetch: (id) ->
        node_obj = @node_objs_by_id[id]
        if node_obj
          node_obj
        else
          null
          
      # [ Called by d&d, at end, we add character1 to node_obj2
      closest: (node_obj) ->
        closest = null
        dist = 40 # Set max distance before keeping a node # TODO : Adjust
        for n_obj in @node_objs
          if n_obj != node_obj # TODO Verify, else add new ids
            cur_dist = node_obj.distance_from(n_obj)
            if cur_dist < dist
              closest = n_obj
              dist = cur_dist
        closest
        
    node_collection = new NodeCollection
    
    ###########################
    # Class corresponding to a Marker on the map
    # TODO : Rename Node -> Marker, node_obj -> marker
    # @node: node model from the server. If @node.real is true, @node correspond s
    # truly to a model in the db, else, it's a fake node.
    # @marker: marker on the map, class from Leaflet
    # @characters: characters models fetch by ids in @node.character_ids
    # @character_names: Property calculated from @characters
    ###########################
    class Node
      # Create a marker on the map
      constructor: (@node) ->
        @targeted = false
        @update_characters()
        @marker = L.marker([@node.latitude, @node.longitude], 
          {"draggable": true, "title": @character_names})
          
        @on_map = false
        if !node_collection.fetch(@node.id)
          node_collection.register(this)
          map.addLayer(@marker)
          @on_map = true
        else
          console.log "#{@node.id} already present"
          
        @resize_marker()
        
        @marker.on('drag', (e) =>
          closest = node_collection.closest(this)
          @deselect_target()
          if closest
            @select_target(closest)
        )
        @marker.on('dragend', (e) =>
          if @target
            # Fuuuuusion !            
            concerned_ch_id = null
            if @node.character_ids.length == 1
              concerned_ch_id = @node.character_ids[0]
            else
              concerned_ch_id = main_character.id
            
            # Join points and create a node
            if @target.node.real
              # Update it
              if @node.real
                # Target and source are real
                # Remove character from the source
                @remove_character(concerned_ch_id)
                # Update target adding a character
                @target.add_character(concerned_ch_id)
              else
                # Only target is real
                # Update it adding a character
                @target.add_character(concerned_ch_id)
            else
              target_ch_id = @target.node.character_ids[0]
              if @node.real
                # Only source is real
                # Deplace source and update it adding a character
                @node.latitude = @target.node.latitude
                @node.longitude = @target.node.longitude
                @add_character(target_ch_id)
              else
                # Nodes aren't real
                # Create a new node
                @node.latitude = @target.node.latitude
                @node.longitude = @target.node.longitude
                @set_node_default_values()
                @node.character_ids.push(target_ch_id)
                @update_characters()
                @create_on_server()
            @deselect_target()
          else
            latlng = @marker.getLatLng()
            @node.latitude = latlng.lat
            @node.longitude = latlng.lng
            if @node.real
              @update_on_server()
            else
              @create_new_real_node()
        )
        @popup = false
        @update_popup()
        #console.log @node, "created"
      
      fill_informations: ->
        @node.title = prompt("Titre")
        @node.resume = prompt("Résumé")
        delete @node.topic_id
      set_default_dates: ->
        @node.begin_at = character_list.last_date
        delete @node.end_at
      set_node_default_values: ->
        delete @node.id
        @fill_informations()
        @set_default_dates()
      create_new_real_node: ->
        @set_node_default_values()
        @create_on_server()
      
      # Updates the position of the marker on the map
      update_latlng: ->
        @marker.setLatLng([@node.latitude, @node.longitude])
      
      # Distance fro another node_obj
      distance_from: (node_obj)->
        latlng = @marker.getLatLng()
        a = latlng.lat - node_obj.node.latitude
        b = latlng.lng - node_obj.node.longitude
        (a*a+b*b)
      
      select_target: (node_obj)->
        @target = node_obj
        node_obj.is_targeted() 
      
      deselect_target: ()->
        if @target
          @target.is_untargeted()
        @target = null
        
      is_targeted: ->
        @targeted = true
        @resize_marker()
        
      is_untargeted: ->
        @targeted = false
        @resize_marker()
      
      # Update whole content of node (popup, positionn, size)
      # according to the content of node
      update_node: (node) ->
        #console.log("Update node content", @node.title, "->", node.title)
        if @node.real == node.real && @node.id == node.id
          # The node is real and hasn't change from the last time
          # We just make it move (normally not necessary but... ?)
          @node = node
          @update_latlng()
        else
          console.log(@node.id, "->", node.id)
          
          # Not the same node as before, update all attributes
          
          node_collection.remove(this)
          
          @node = node
          @update_characters() if @node.real
          
          if node_collection.fetch(@node.id)
            # Already present on the map (topic)
            if @on_map
              map.removeLayer(@marker)
              @on_map = false
          else
            # Not present, add it
            node_collection.register(this)
            if !@on_map
              map.addLayer(@marker)
              @on_map = true
            
          @resize_marker()
          @update_popup()
          @update_latlng()
          
      # Return the content of the popup of the marker.
      # Must be null to not create a popup
      popup_content: ->
        if @node.real
          str = ""
          str += "<h4>#{@node.title}</h4>" if !blank(@node.title)
          str += "<p>#{@node.resume}</p>" if !blank(@node.resume)
          str += "<small>#{@character_names}</small>" if !blank(@character_names)
        else
          null
        
      # Change the icon of the marker according the importance of the node
      resize_marker: ->
        if @targeted
          # Fusion will come
          @marker.setIcon(bigPointIcon)
        else if @node.real && @node.title && @node.title.length > 0
          # Real node with a title
          if @node.topic_id
            # This node include a topic
            @marker.setIcon(bigPointIcon)
          else
            # This node is just an information of deplacement
            @marker.setIcon(mediumPointIcon)
        else
          # Not real node (character is in a traject) or Node has'nt a title
          @marker.setIcon(smallPointIcon)
      
      # Remove the marker from the map
      destroy_popup: ->
        @marker.closePopup()
        @marker.unbindPopup()
        @popup = false
      # Update the popup of the node, remove it if necessary
      update_popup: ->
        cont = @popup_content()
        if cont?
          if @popup
            # Only update content
            @marker.setPopupContent cont
          else
            # Create a new popup
            @marker.bindPopup cont
            @popup = true
        else
          # Not real node
          @destroy_popup()
        
      # Destroy popup and marker
      destroy: ->
        @destroy_popup()
        if @on_map
          node_collection.remove(this)
          map.removeLayer(@marker)
        delete @marker
      # Idem + on server
      really_destroy: ->
        @delete_on_server()
        @destroy()
        
      # Fetch characters model by @node.character_ids
      # Calculate @character_names
      update_characters: ->
        @characters = []
        for ch_id in @node.character_ids
          @characters.push(characters_by_id[ch_id])
        @character_names = ""
        for character in @characters
          @character_names += character.name + ' '
          
      # add a character to the node (serverside too)
      add_character: (id)->
        @node.character_ids.push(id)
        @update_characters()
        @update_on_server()
        
      # remove a character from the node
      # if the node has only one character, it is removed
      remove_character: (id)->
        if @node.character_ids.length <= 1
          @really_destroy()
        else
          # TODO TODO TODO
          # Remove character id from @node.character_ids
          @update_characters()
          @update_on_server()
      
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
            #console.log "Node #{@node.id} updated on server."
          error: =>
            alert "Error on server ! Node #{@node.id} can't be updated."
      # Create @node on server
      create_on_server: ->
        #alert('create on server !')
        $.ajax
          type: "POST"
          url: "/nodes/"
          data: 
            node: @node
          dataType: "json"
          success: (a, b, c, d) =>
            console.log "Node created on server. Res :", a, ",", b, ",", c, ",", d
            @node.id = null # TODO : set the @node.id
            @node.real = true
          error: =>
            alert "Error on server ! Node can't be created."
      # Update @node on server
      delete_on_server: ->
        alert("delete a non real node !") unless @node.id != 0
        $.ajax
          type: "DELETE"
          url: "/nodes/"+@node.id
          dataType: "json"
          success: =>
            console.log "Node #{@node.id} deleted on server."
          error: =>
            alert "Error on server ! Node #{@node.id} can't be deleted."
    
    character_list = new CharacterList
    
    ###############
    # Date Slider #
    ###############
    $date_slider = $("#date-slider")
    $date_value = $("#date-value")
    from = j_date(json_data($date_slider, "from"))
    to = j_date(json_data($date_slider, "to"))
    hour_in_ms = 1000*60*60
    day_in_ms = hour_in_ms*24
    
    # Modif the sample to precise the time
    sample = hour_in_ms
    
    duration = (to-from)/sample
    
    # Send the date to the character_list
    update_date = (date)->
      $date_value.text(date.toLocaleString())
      character_list.update_date(date)
    # Begin to the current date (the last)
    update_date(to)
    # Set the slider correctly
    $date_slider.slider
      min: 0
      max: duration
      value: duration
      slide: (event, ui) ->
        new_date = new Date(from.valueOf()+ui.value*sample)
        update_date(new_date)
    
