
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
        radius: 200,                         // the Cascade.config() method.
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
    maxNodeSize: 5,
    minEdgeSize: 1,
    maxEdgeSize: 1
  }).mouseProperties({
    maxRatio: 4, // Max zoom
    minRatio: minRatio // Max dezoom
  });
/*** END : CEREBRO INSTANTIATION ***/

/*** NODE AND EDGE INSTANTIATION ***/
  var characters = $cerebro.data('characters');
  var characters_by_id = $cerebro.data('characters_by_id');
  var links = $cerebro.data('links');
  var links_by_id = $cerebro.data('links_by_id');
  
  /* NODES */
  for (var ch_ind in characters) {
    character = characters[ch_ind];
    console.log("Add character", character, character.id, character.name);
    
    var node = {label: character.name, attributes:[], color: 'rgb(119,221,119)'}; // Create basic node
    /* Add attributes to node */
   	node.attributes = {};
   	node.attributes['First name'] = character.first_name;
    node.attributes['Last name'] = character.last_name;
    node.attributes['Birth date'] = character.birth_date;
    node.attributes['Birth place'] = character.birth_place;
    node.attributes['Sex'] = character.sex;
    node.attributes['About'] = character.anecdote;
    /*node.attributes.push({attr:'First name', val:character.first_name});
    node.attributes.push({attr:'Last name', val:character.last_name});
    node.attributes.push({attr:'Birth date', val:character.birth_date});
    node.attributes.push({attr:'Birth place', val:character.birth_place});
    node.attributes.push({attr:'Sex', val:character.sex});
    node.attributes.push({attr:'About', val:character.anecdote});*/
    
	sigInst.addNode('c'+character.id,node); // Add node to cerebro
  }
  
  /* EDGES */
  for (var li_ind in links) {
    link = links[li_ind];
    console.log("Add link", link, link.id, link.from_character_id, link.to_character_id);
    sigInst.addEdge(
      'l'+link.id,
      'c'+link.from_character_id,
      'c'+link.to_character_id
    );
  }
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
		console.log(sigInst);
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
	    
	    /*sigInst.iterEdges(function(e){
			if(e.source == nodeOfInterest.id || e.target == nodeOfInterest.id){
		        e.hidden = 0;
		    }
		    else {
		    	e.hidden = 1;
		    }
	    }).draw(2,2,2);*/
	    
	    /*sigInst.iterNodes(function(n){
	      	if (n.id != nodeOfInterest.id) {
				n.hidden = 1;
			}
			else {
				n.hidden = 0;
			}
	    }).draw(2,2,2);*/
	    
    	console.log("test");
	};
	
	sigma.publicPrototype.sexFilter = function(b) {
		sigInst.iterNodes(function(n){
	      	if (n.attr.attributes["Sex"] == b) {
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
/*** END : FILTERS ***/
  
/*** GREY COLOR FOR NOT SELECTED NODES ***/
  var greyColor = '#666';
  sigInst.bind('overnodes',function(event){
    var nodes = event.content;
    var neighbors = {};
    sigInst.iterEdges(function(e){
      if(nodes.indexOf(e.source)<0 && nodes.indexOf(e.target)<0){
        if(!e.attr['grey']){
          e.attr['true_color'] = e.color;
          e.color = greyColor;
          e.attr['grey'] = 1;
        }
      }else{
        e.color = e.attr['grey'] ? e.attr['true_color'] : e.color;
        e.attr['grey'] = 0;
 
        neighbors[e.source] = 1;
        neighbors[e.target] = 1;
      }
    }).iterNodes(function(n){
      if(!neighbors[n.id]){
        if(!n.attr['grey']){
          n.attr['true_color'] = n.color;
          n.color = greyColor;
          n.attr['grey'] = 1;
        }
      }else{
        n.color = n.attr['grey'] ? n.attr['true_color'] : n.color;
        n.attr['grey'] = 0;
      }
    }).draw(2,2,2);
  }).bind('outnodes',function(){
    sigInst.iterEdges(function(e){
      e.color = e.attr['grey'] ? e.attr['true_color'] : e.color;
      e.attr['grey'] = 0;
    }).iterNodes(function(n){
      n.color = n.attr['grey'] ? n.attr['true_color'] : n.color;
      n.attr['grey'] = 0;
    }).draw(2,2,2);
  });
/*** END : GREY COLOR FOR NOT SELECTED NODES ***/

/*** LEGEND TO NODE ***/
  (function(){
    var popUp;
 
    // Create a list with every node attribute
    /*function attributesToString(attr) {
      return '<ul>' +
        attr.map(function(o){
          return '<li>' + o.attr + ' : ' + o.val + '</li>';
        }).join('') +
        '</ul>';
    }*/
   	function attributesToString(attr) {
   		var attrStr = '<ul>';
  		$.each(attr, function(key, value) {
			attrStr += '<li>' + key + ' : ' + value + '</li>';
		});
        attrStr += '</ul>';
        return attrStr;
    }
 
    function showNodeInfo(event) {
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
    }
 	
    sigInst.bind('overnodes',showNodeInfo).bind('outnodes',hideNodeInfo).draw();
  })();
/*** END : LEGEND TO NODE ***/

/*** REMOVE FISH EYE ON ZOOM ***/
  document.onmousewheel = function(event){ // On mouse wheel...
  	clearTimeout($.data(this, 'scrollTimer'));
    $.data(this, 'scrollTimer', setTimeout(function() {
        //console.log("Haven't scrolled in 250ms!");
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
  
  //sigInst.startForceAtlas2();
  //setTimeout(function(){sigInst.stopForceAtlas2();},5000);

	// Add circular layout to a button
    document.getElementById('circular').addEventListener('click',function(){
    	sigInst.myCircularLayout();
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
	
	document.getElementById('noFilter').addEventListener('click',function(){
    	sigInst.noFilter();
	},true);
  
  
/*** END : ADD LAYOUT AND PLUG-IN TO CEREBRO ***/

}
 
if (document.addEventListener) {
  document.addEventListener('DOMContentLoaded', init, false);
} else {
  window.onload = init;
}