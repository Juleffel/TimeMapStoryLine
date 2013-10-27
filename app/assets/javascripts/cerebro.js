
function init() {
  var cerebro = document.getElementById('cerebro');
  if (cerebro == null) return;
  
/*** FISH EYE ***/
  (function(){
    var FishEye = function(sig) { 
      sigma.classes.Cascade.call(this);      // The Cascade class manages the chainable property
                                             // edit/get function.
 
      var self = this;                       // Used to avoid any scope confusion.
      var isActivated = false;               // Describes is the FishEye is activated.
 
      this.p = {                             // The object containing the properties accessible with
        radius: 100,                         // the Cascade.config() method.
        power: 2
      };
 
      function applyFishEye(mouseX, mouseY) {   // This method will apply a formula relatively to
                                                // the mouse position.
        var newDist, newSize, xDist, yDist, dist,
            radius   = self.p.radius,
            power    = self.p.power,
            powerExp = Math.exp(power);
 
        sig.graph.nodes.forEach(function(node) {
          xDist = node.displayX - mouseX;
          yDist = node.displayY - mouseY;
          dist  = Math.sqrt(xDist*xDist + yDist*yDist);
 
          if(dist < radius){
            newDist = powerExp/(powerExp-1)*radius*(1-Math.exp(-dist/radius*power));
            newSize = powerExp/(powerExp-1)*radius*(1-Math.exp(-dist/radius*power));
 
            if(!node.isFixed){
              node.displayX = mouseX + xDist*(newDist/dist*3/4 + 1/4);
              node.displayY = mouseY + yDist*(newDist/dist*3/4 + 1/4);
            }
 
            node.displaySize = Math.min(node.displaySize*newSize/dist,10*node.displaySize);
          }
        });
      };
 
      // The method that will be triggered when Sigma's 'graphscaled' is dispatched.
      function handler() {
        applyFishEye(
          sig.mousecaptor.mouseX,
          sig.mousecaptor.mouseY
        );
      }
 
      this.handler = handler;
 
      // A public method to set/get the isActivated parameter.
      this.activated = function(v) {
        if(v==undefined){
          return isActivated;
        }else{
          isActivated = v;
          return this;
        }
      };
 
      // this.refresh() is just a helper to draw the graph.
      this.refresh = function(){
        sig.draw(2,2,2);
      };
    };
 
    // Then, let's add some public method to sigma.js instances :
    sigma.publicPrototype.activateFishEye = function() {
      if(!this.fisheye) {
        var sigmaInstance = this;
        var fe = new FishEye(sigmaInstance._core);
        sigmaInstance.fisheye = fe;
      }
 
      if(!this.fisheye.activated()){
        this.fisheye.activated(true);
        this._core.bind('graphscaled', this.fisheye.handler);
        document.getElementById(
          'sigma_mouse_'+this.getID()
        ).addEventListener('mousemove',this.fisheye.refresh,true);
      }
 
      return this;
    };
 
    sigma.publicPrototype.deactivateFishEye = function() {
      if(this.fisheye && this.fisheye.activated()){
        this.fisheye.activated(false);
        this._core.unbind('graphscaled', this.fisheye.handler);
        document.getElementById(
          'sigma_mouse_'+this.getID()
        ).removeEventListener('mousemove',this.fisheye.refresh,true);
      }
 
      return this;
    };
 
    sigma.publicPrototype.fishEyeProperties = function(a1, a2) {
      var res = this.fisheye.config(a1, a2);
      return res == s ? this.fisheye : res;
    };
  })();
/*** END : FISH EYE ***/

/*** CEREBRO INSTANTIATION ***/
  //var defaultColor = 'rgb(119,221,119)';
  var defaultColor = '#fff';
  var deselectColor = '#000';
  var $cerebro = $(cerebro);
  var minRatio = 0.5;
  var sigInst = sigma.init(cerebro).drawingProperties({
    defaultLabelColor: '#fff',
    defaultLabelSize: 14,
    defaultLabelBGColor: '#fff',
    defaultLabelHoverColor: '#000',
    labelThreshold: 6,
    defaultEdgeType: 'curve'
  }).graphProperties({
    minNodeSize: 0.5,
    maxNodeSize: 4,
    minEdgeSize: 1,
    maxEdgeSize: 1
  }).mouseProperties({
    maxRatio: 4, // Max zoom
    minRatio: minRatio // Max dezoom
  });
/*** END : CEREBRO INSTANTIATION ***/

/*** NODE AND EDGE INSTANTIATION ***/
  var characters = $cerebro.data('characters');
  var characters_by_id = $cerebro.data('characters-by-id');
  var links = $cerebro.data('links');
  var links_by_id = $cerebro.data('links-by-id');
  var groups = $cerebro.data('groups');
  var groups_by_id = $cerebro.data('groups-by-id');
  
  /* NODES */
  for (var ch_ind in characters) {
    character = characters[ch_ind];
    
    var node = {label: character.name, color: groups_by_id[character.group_id].color}; // Create basic node

    /* Add character attributes to node */
   	node['First name'] = character.first_name;
    node['Last name'] = character.last_name;
    node['Birth date'] = character.birth_date;
    node['Birth place'] = character.birth_place;
    node['Sex'] = character.sex?"Homme":"Femme";
    node['Group'] = groups_by_id[character.group_id].name;
    node['About'] = character.anecdote;
    
    /* Add other attributes to node */
    node['temp'] = []; // These attributes will be not displayed as character information !
	node['temp']['group_id'] = character.group_id;
    node['temp']['true_color'] = node.color;
    
	sigInst.addNode('c'+character.id,node); // Add node to cerebro
  }
  
  /* EDGES */
  for (var li_ind in links) {
    link = links[li_ind];
    sigInst.addEdge(
      'l'+link.id,
      'c'+link.from_character_id,
      'c'+link.to_character_id
    );
  }
  sigInst.iterEdges(function(e){
	      e.color = defaultColor;
  }).draw(2,2,2);
/*** END : NODE AND EDGE INSTANTIATION ***/
  
/*** LAYOUT ALGORITHM ***/
  sigma.publicPrototype.myLayout = function() { 
    this.iterNodes(function(n){
      n.x = Math.random(); // Random for now...
      n.y = Math.random();
    });
 
    return this.position(0,0,1).draw();
  };
/*** END : LAYOUT ALGORITHM ***/

/*** CIRCULAR LAYOUT ***/
	sigma.publicPrototype.myCircularLayout = function() {
    	var R = 100,
        	i = 0,
        	L = this.getNodesCount();
 
    	this.iterNodes(function(n){
			n.x = Math.cos(Math.PI*(i++)/L)*R; // Biology is logical, math is magical...
			n.y = Math.sin(Math.PI*(i++)/L)*R;
    	});
 
		return this.position(0,0,1).draw();
	};
/*** END : CIRCULAR LAYOUT ***/

/*** FILTERS ***/
	sigma.publicPrototype.amoFilter = function() {
		var nodeOfInterest;
		var neighbors = {};
		sigInst.iterNodes(function(n){ // Iterate nodes to retrieve the node of interest
			if (n.label == "Amosis Opilion") {
				nodeOfInterest = n;
			}
	    });
	    sigInst.iterEdges(function(e){ // Iterate edges to retrieve neighbors
	      if(e.source == nodeOfInterest.id || e.target == nodeOfInterest.id){
	        neighbors[e.source] = 1;
	        neighbors[e.target] = 1;
	      }
	    }).iterNodes(function(n){ // Iterate nodes to hide every node which are not a node of interest or a neighbor
	      if(!neighbors[n.id]){
	        n.hidden = 1;
	      }else{
	        n.hidden = 0;
	      }
	    }).iterEdges(function(e){ // Iterate edges to hide every link which are not from the node of interest
	    	if (e.source != nodeOfInterest.id && e.target != nodeOfInterest.id) {
	    		e.hidden = 1;
	    	}
	    }).draw(2,2,2);
	};
	
	sigma.publicPrototype.sexFilter = function(b) {
		sigInst.iterNodes(function(n){
	      	if (n.attr["Sex"] == b) {
				n.hidden = 0;
			}
			else {
				n.hidden = 1;
			}
	    }).draw(2,2,2);
	};
	
	sigma.publicPrototype.noFilter = function() {
		sigInst.iterNodes(function(n){ // Iterate nodes to display them
	      	n.hidden = 0;
	   }).iterEdges(function(e){ // Iterate edges to display them
	      	e.hidden = 0;
	    }).draw(2,2,2);
	};
	
	sigma.publicPrototype.groupFilter = function(groupName) {
		if (groupName){ // If a group name is selected
			sigInst.iterNodes(function(n){ // Iterate nodes...
				if (groups_by_id[n.attr['temp']['group_id']].name == groupName) { // Display node if it comes from the selected group
		      		n.hidden = 0;
		        }
				else {
					n.hidden = 1;
				}
		     }).draw(2,2,2);
		     updateSearchBox(groupName);
		}
		else { // Without selected group name, 
			sigInst.noFilter(); // We display the entire graph
			initSearchBox();
		}
		
	};
	
/*** END : FILTERS ***/
  
/*** GREY COLOR FOR NOT SELECTED NODES ***/

function changeColor(nodes) {
	if (nodes == null) { // If there is no selected node
		sigInst.iterNodes(function(n){ // Iterate nodes to give them their default color
			n.color = n.attr['temp']['true_color'];
		}).iterEdges(function(e){ // Iterate nodes to give them their default color
			e.color = defaultColor;
		}).draw(2,2,2);
	}
	else { // If a node is selected
		var neighbors = {};
    	neighbors[nodes[0]] = 1; // The selected node is also stored as its neighbor
	    sigInst.iterEdges(function(e){ // Iterate edges...
	      if(nodes.indexOf(e.source)<0 && nodes.indexOf(e.target)<0){ // If this is not a link from the node of interest,
	        e.color = deselectColor; // We deselect the edge
	      }else{ // Else,
	        e.color = defaultColor; // We display the edge and we store the concerned nodes as neighbors
	        neighbors[e.source] = 1;
	        neighbors[e.target] = 1;
	      }
	    }).iterNodes(function(n){ // Iterate nodes to display every neighbor with the default color and deselect the others
	      if(!neighbors[n.id]){
	        n.color = deselectColor;
	      }else{
	        n.color = n.attr['temp']['true_color'];
	      }
	    }).draw(2,2,2);
    }
}

  sigInst.bind('downnodes',function(event){ // On node click
    var nodes = event.content;
	changeColor(nodes); // We change the graph color according to the selected node
	
    sigInst.iterNodes(function(n){ // Iterate node to update the search box according to the selected node name
		if (n.id == nodes[0]) {
			document.getElementById('searchNode').value = n.label;
		}
	});
	
  });
/*** END : GREY COLOR FOR NOT SELECTED NODES ***/

/*** LEGEND TO NODE ***/
 
   	function attributesToString(attr) {
   		/* Method which create a list from node information */
   		var attrStr = '<ul>';
  		$.each(attr, function(key, value) {
  			if (key != "temp") { // We display only the character information
				attrStr += '<li>' + key + ' : ' + value + '</li>';
			}
		});
        attrStr += '</ul>';
        return attrStr;
    }
    
    var divNodeInfo = document.getElementById('nodeinfo');
    
    function showNodeInfo(event) {
 	  /* Method which display information according to the selected node */
      var node;
      sigInst.iterNodes(function(n){
        node = n;
      },[event.content[0]]);
	  divNodeInfo.innerHTML = attributesToString( node.attr );
    }
    
    sigInst.bind('downnodes',showNodeInfo).draw();
/*** END : LEGEND TO NODE ***/

/*** SEARCH BOX ***/

	var namesForSearchBox = [];
	function initSearchBox() {
    	sigInst.iterNodes(function(n){ // Iterate nodes to add their names to the search box
			namesForSearchBox.push(n.label);
		});
		emptySearchBox();
	    $('#searchNode').autocomplete({source: namesForSearchBox});
	}
	initSearchBox();
	
	function updateSearchBox(groupName) {
		namesForSearchBox = [];
		sigInst.iterNodes(function(n){ // Iterate nodes to add their names to the search box
			if (groups_by_id[n.attr['temp']['group_id']].name == groupName) {
				namesForSearchBox.push(n.label);
			}
	    });
	    emptySearchBox();
	    $('#searchNode').autocomplete({source: namesForSearchBox});
	}
	
	function emptySearchBox() {
		document.getElementById('searchNode').value = ""; // We remove this value
	    document.getElementById('nodeinfo').innerHTML = ""; // We remove the node information displayed
	    changeColor(null); // We give the default colors
	}
	    
    $('#searchNode').autocomplete({ // Autocompletion parameters
      select: function(event, ui){
            document.getElementById('searchNode').value = ui.item.label; // The search box value is changed according to the selected name
            
            var node;
            sigInst.iterNodes(function(n){ // Iterate nodes to retrieve the node corresponding to the selected name
                        if (n.label == event.target.value) {
                                node = n;
                        }
                });
                
                if (node) { // If a node is selected,
                	document.getElementById('nodeinfo').innerHTML = attributesToString( node.attr ); // Display information about it
                	var nodes = [node.id];
                	changeColor(nodes); // Change color according to this selection
               }
      }
    }).keyup(function (e) {
	    if (e.keyCode == 13) { // System to handle the use of the "Enter" key
	    	if (names.indexOf(document.getElementById('searchNode').value) < 0) { // If the current value does not correspond to a node name, we consider this as an expected deselection
	    		emptySearchBox();
	        }
	    }
	});  		

/*** END : SEARCH BOX ***/

/*** REMOVE FISH EYE ON ZOOM ***/
  document.onmousewheel = function(event){ // On mouse wheel...
  	clearTimeout($.data(this, 'scrollTimer'));
    $.data(this, 'scrollTimer', setTimeout(function() {
    	/* Function called after 250ms without scrolling.
    	   The goal here is to handle the end of the scroll to activate or deactivate the fish eye
    	   according to the current ratio (because a fish eye at the maximum zoom is just insane
    	   for your eyes, and also for your stomach, and also for your computer which will be
    	   probably filled by a puddle of your last lunch...)
    	   */
        var ratio = sigInst.position().ratio; // Retrieve current ratio
	  	if (Math.abs(ratio-minRatio) <= 0.1 ) {
	  		sigInst.activateFishEye(); // Activate the fish eye only on max dezoom
	  	}
	  	else {
		  	sigInst.deactivateFishEye();
		}
    }, 250));
  };
  
/*** END :REMOVE FISH EYE ON ZOOM ***/

/*** ADD LAYOUT AND PLUG-IN TO CEREBRO ***/
  sigInst.myLayout();
  sigInst.activateFishEye().draw();
/*** END : ADD LAYOUT AND PLUG-IN TO CEREBRO ***/

/*** ADD EVENTS ***/
  
	// Add circular layout to a button
    document.getElementById('circular').addEventListener('click',function(){
    	sigInst.myCircularLayout();
	},true);
	
	// Run forceatlas
    document.getElementById('forceAtlas').addEventListener('click',function(){
    	sigInst.startForceAtlas2();
  		setTimeout(function(){sigInst.stopForceAtlas2();},500);
	},true);
	
	// Button filters
	document.getElementById('amoFilter').addEventListener('click',function(){
    	sigInst.amoFilter();
	},true);
	/*document.getElementById('menFilter').addEventListener('click',function(){
    	sigInst.sexFilter(true);
	},true);
	document.getElementById('womenFilter').addEventListener('click',function(){
    	sigInst.sexFilter(false);
	},true);
	document.getElementById('inquiFilter').addEventListener('click',function(){
    	sigInst.inquiFilter();
	},true);
	document.getElementById('noFilter').addEventListener('click',function(){
    	sigInst.noFilter();
	},true);*/
	
	// Group list filters
	document.getElementById('group_name').addEventListener('change',function(){
		sigInst.groupFilter(this.value);
	},true);
  
/*** END : ADD EVENTS ***/

}
 
if (document.addEventListener) {
  document.addEventListener('DOMContentLoaded', init, false);
} else {
  window.onload = init;
}