
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

    /* Add attributes to node */
   	node['First name'] = character.first_name;
    node['Last name'] = character.last_name;
    node['Birth date'] = character.birth_date;
    node['Birth place'] = character.birth_place;
    node['Sex'] = character.sex;
    node['Group'] = groups_by_id[character.group_id].name;
    node['About'] = character.anecdote;
    
    node['temp'] = [];
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
			n.x = Math.cos(Math.PI*(i++)/L)*R;
			n.y = Math.sin(Math.PI*(i++)/L)*R;
    	});
 
		return this.position(0,0,1).draw();
	};
/*** END : CIRCULAR LAYOUT ***/

/*** FILTERS ***/
	sigma.publicPrototype.amoFilter = function() {
		var nodeOfInterest;
		var neighbors = {};
		sigInst.iterNodes(function(n){
			if (n.label == "Amosis Opilion") {
				nodeOfInterest = n;
			}
	    });
	    
	    sigInst.iterEdges(function(e){
	      if(e.source == nodeOfInterest.id || e.target == nodeOfInterest.id){
	        neighbors[e.source] = 1;
	        neighbors[e.target] = 1;
	      }
	    }).iterNodes(function(n){
	      if(!neighbors[n.id]){
	        n.hidden = 1;
	      }else{
	        n.hidden = 0;
	      }
	    }).iterEdges(function(e){
	    	if (e.source != nodeOfInterest.id && e.target != nodeOfInterest.id) {
	    		e.hidden = 0;
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
		sigInst.iterNodes(function(n){
	      	n.hidden = 0;
	    }).iterEdges(function(e){
	      	e.hidden = 0;
	    }).draw(2,2,2);
	};
	
	sigma.publicPrototype.inquiFilter = function() {
		sigInst.iterNodes(function(n){
			if (groups_by_id[n.attr['temp']['group_id']].name == "Inquisition") {
	      		n.hidden = 0;
	        }
			else {
				n.hidden = 1;
			}
	     }).draw(2,2,2);
	};
	
	sigma.publicPrototype.groupFilter = function(groupName) {
		if (groupName){
			sigInst.iterNodes(function(n){
				if (groups_by_id[n.attr['temp']['group_id']].name == groupName) {
		      		n.hidden = 0;
		        }
				else {
					n.hidden = 1;
				}
		     }).draw(2,2,2);
		}
		else {
			sigInst.noFilter();
		}
	};
	
	
/*** END : FILTERS ***/
  
/*** GREY COLOR FOR NOT SELECTED NODES ***/

function changeColor(nodes) {
	if (nodes == null) {
		sigInst.iterNodes(function(n){
			n.color = n.attr['temp']['true_color'];
		}).iterEdges(function(e){
			e.color = defaultColor;
		}).draw(2,2,2);
	}
	else {
		var neighbors = {};
    	neighbors[nodes[0]] = 1;
	    sigInst.iterEdges(function(e){
	      if(nodes.indexOf(e.source)<0 && nodes.indexOf(e.target)<0){
	        e.color = deselectColor;
	      }else{
	        e.color = defaultColor;
	        neighbors[e.source] = 1;
	        neighbors[e.target] = 1;
	      }
	    }).iterNodes(function(n){
	      if(!neighbors[n.id]){
	        n.color = deselectColor;
	      }else{
	        n.color = n.attr['temp']['true_color'];
	      }
	    }).draw(2,2,2);
    }
}

  sigInst.bind('downnodes',function(event){
    var nodes = event.content;
	changeColor(nodes);
	
    sigInst.iterNodes(function(n){
		if (n.id == nodes[0]) {
			document.getElementById('searchNode').value = n.label;
		}
	});
	
  });
/*** END : GREY COLOR FOR NOT SELECTED NODES ***/

/*** LEGEND TO NODE ***/
 // (function(){
    //var popUp;
 
   	function attributesToString(attr) {
   		var attrStr = '<ul>';
  		$.each(attr, function(key, value) {
  			if (key != "temp") {
				attrStr += '<li>' + key + ' : ' + value + '</li>';
			}
		});
        attrStr += '</ul>';
        return attrStr;
    }
 
    /*function showNodeInfo(event) {
      popUp && popUp.remove();
 
      var node;
      sigInst.iterNodes(function(n){
        node = n;
      },[event.content[0]]);
   
      popUp = $(
        '<div class="node-info-popup"></div>'
      ).append(
        attributesToString( node.attr.attributes )
      ).attr(
        'id',
        'node-info'+sigInst.getID()
      ).css({
        'display': 'inline-block',
        'border-radius': 3,
        'padding': 5,
        'background': '#fff',
        'color': '#000',
        'box-shadow': '0 0 4px #666',
        'position': 'absolute',
        'left': node.displayX,
        'top': node.displayY+15
      });
 
      $('ul',popUp).css('margin','0 0 0 20px');
 
      $cerebro.append(popUp);
    }
 
    function hideNodeInfo(event) {
      popUp && popUp.remove();
      popUp = false;
    }*/
 	
    //sigInst.bind('overnodes',showNodeInfo).bind('outnodes',hideNodeInfo).draw();
    
    var divNodeInfo = document.getElementById('nodeinfo');
    
    function showNodeInfo(event) {
 
      var node;
      sigInst.iterNodes(function(n){
        node = n;
      },[event.content[0]]);
   
	  divNodeInfo.innerHTML = attributesToString( node.attr );
 
      //$cerebro.append(popUp);
    }
    
    sigInst.bind('downnodes',showNodeInfo).draw();
//  })();
/*** END : LEGEND TO NODE ***/

/*** SEARCH BOX ***/
//$(function() {
    var names = [];
    sigInst.iterNodes(function(n){
		names.push(n.label);
	});
	    
    $('#searchNode').autocomplete({
      source: names,
      select: function(event, ui){
            document.getElementById('searchNode').value = ui.item.label;
            
            var node;
            sigInst.iterNodes(function(n){
                        if (n.label == event.target.value) {
                                node = n;
                        }
                });
                
                if (node) {
                	document.getElementById('nodeinfo').innerHTML = attributesToString( node.attr );
                	var nodes = [node.id];
                	changeColor(nodes);
               }
            
            //showNodeInfo(event);
      }
    }).keyup(function (e) {
    if (e.keyCode == 13) {
    	if (names.indexOf(document.getElementById('searchNode').value) < 0) {
    		document.getElementById('searchNode').value = "";
        	document.getElementById('nodeinfo').innerHTML = "";
        	changeColor(null);
        }
    }});
    
    /*sigInst.bind('downgraph',function(event){
    	document.getElementById('searchNode').value = "";
        document.getElementById('nodeinfo').innerHTML = "";
        changeColor(null);
    }).draw();*/

//});	  		

/*** END : SEARCH BOX ***/

/*** REMOVE FISH EYE ON ZOOM ***/
  document.onmousewheel = function(event){ // On mouse wheel...
  	clearTimeout($.data(this, 'scrollTimer'));
    $.data(this, 'scrollTimer', setTimeout(function() {
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
  
	// Add circular layout to a button
    document.getElementById('circular').addEventListener('click',function(){
    	sigInst.myCircularLayout();
	},true);
	
	// Run forceatlas
    document.getElementById('forceAtlas').addEventListener('click',function(){
    	sigInst.startForceAtlas2();
  		setTimeout(function(){sigInst.stopForceAtlas2();},500);
	},true);
	
	document.getElementById('amoFilter').addEventListener('click',function(){
    	sigInst.amoFilter();
	},true);
	
	document.getElementById('menFilter').addEventListener('click',function(){
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
	},true);
	
	document.getElementById('group_name').addEventListener('change',function(){
		sigInst.groupFilter(this.value);
	},true);
  
  
/*** END : ADD LAYOUT AND PLUG-IN TO CEREBRO ***/

}
 
if (document.addEventListener) {
  document.addEventListener('DOMContentLoaded', init, false);
} else {
  window.onload = init;
}