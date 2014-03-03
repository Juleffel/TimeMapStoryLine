sigma.publicPrototype.bindEvents = function ($data_container) {
  dom = document.querySelector('#js-graph canvas:last-child');
  edgeCanvas = document.querySelector('#sigma_hover_1');
  ctx = edgeCanvas.getContext('2d');
  var letsdraw = false;
	
  var sigInst = this;
  var $element = $(this);
  mouseDown = false;
  selectedNodeName = null;
  selectedNode2Name = null;
  selectedNode = null;
  selectedNode2 = null;
  var popUp;
  
  /*** ACTIONS ON GRAPH EVENTS ***/
  function submitNewInteraction() {
  
  	var nodes_by_id = $data_container.data('nodes-by-id');
	$.ajax({
        type: "POST",
        url:  "/links",
        data: {link:{from_character_id: selectedNode.attr.temp.node_id,
        	to_character_id: selectedNode2.attr.temp.node_id,
        	title: $('#link_title').val(), 
    		description: $('#link_descript').val(),
    		force: 50}}
      }).done(function( data ) {
      	 location.reload();
      });
  }
  function cancelNewInteraction() {
  	popUp && popUp.remove();
  }
  mouseDownOvernodes = function(e) {
  	if( e.which == 1 ) {
  	   	  selectedNodeName = overNodeName;
  	   	  
	  	// When clic on node without release : start line drawing
	  	popUp && popUp.remove();
	  	mouseDown = true;
	  	
	  	sigInst.iterNodes(function (n) {
			if (n.id == selectedNodeName) {
				selectedNode = n;
			}
		});
		
		letsdraw = true;
	    ctx.strokeStyle = 'white';
	    ctx.lineWidth = 1;
	    ctx.lineCap = 'round';
	    debX = selectedNode.displayX;//e.pageX;
	    debY = selectedNode.displayY;//e.pageY;
    
    
   }
  };
  mouseUpOvernodes = function(e) {
  	
  	if( e.which == 1 ) {
  	   	  if (overNodeName != selectedNodeName) {
  	   	  	selectedNode2Name = overNodeName;
  	   	  }

	  	// When release clic on node :
	  	//		- if the node is the same as mousedown, we display it info
	  	//		- if the node is a second one, we create a link between the two nodes
	  	
	  	if (selectedNode2Name == null || selectedNode2Name == selectedNodeName) {
	  		sigInst.hideNodeinfo();
	    	sigInst.showNodeinfo(selectedNodeName);
	  	}
	  	else {
	  		console.log("Link creation between "+selectedNodeName+ " and "+selectedNode2Name);
	  		
	  		sigInst.iterNodes(function (n) {
			    if (n.id == selectedNodeName) {
			      selectedNode = n;
			    }
			    else if (n.id == selectedNode2Name) {
			      selectedNode2 = n;
			    }
			  });
	  		
	  		popUp = $(
	          '<div class="node-info-popup"></div>'
	        ).append(
	      		"Vous souhaitez créer un lien entre "+selectedNode.label+ " et "+selectedNode2.label+" ?"+
	      		'<br />Titre du lien : <input id="link_title" type="text" placeholder="Entrez un titre">'+
	      		'<br />Description : <input id="link_descript" type="text" placeholder="Entrez une description">'+
	      		'<br /><button id="submitNewInt">Confirmer</button>'+'<button id="cancelNewInt">Annuler</button>'
	    	).attr(
	          'id',
	          'link-creation'+sigInst.getID()
	        ).css({
	          'display': 'inline-block',
	          'border-radius': 3,
	          'padding': 5,
	          'background': '#fff',
	          'color': '#000',
	          'box-shadow': '0 0 4px #666',
	          'position': 'absolute',
	          'z-index': 10,
	          'left': '50%',
	          'top': '50%'
	        });
	        
	        $(document.getElementById('js-graph')).append(popUp);
	        
		    $('#submitNewInt').click(submitNewInteraction);
		    $('#cancelNewInt').click(cancelNewInteraction);

	  	}
	    
	    // At the end of mouse release, we return at the beginning state 
	    mouseDown = false;
	  	selectedNodeName = null;
	  	selectedNode2Name = null;
	  	letsdraw = false;
	  	ctx.clearRect(0, 0, dom.offsetWidth, dom.offsetHeight);

  	}
  };
  mouseDownOutnodes = function(e) {
  	/*if( e.which == 1 ) {
  		popUp && popUp.remove();
    }*/
  };
  mouseUpOutnodes = function(e) {
  	if( e.which == 1 ) {
  	
	    // At the end of mouse release, we return at the beginning state
	  	mouseDown = false;
	  	selectedNodeName = null;
	  	selectedNode2Name = null;
	  	letsdraw = false;
	  	ctx.clearRect(0, 0, dom.offsetWidth, dom.offsetHeight);
	}
  };
  
  dom.addEventListener('mousemove', function(e) {
    // On mouse move, we draw the line if there is a clicked node
    
    if (mouseDown == true) {
  		sigInst.iterNodes(function (n) {
			if (n.id == selectedNodeName) {
				selectedNode = n;
			}
		});
  		
  		// Voir pour choper un update de selectedNode, en bouclant sur les noeuds pour recup le noeud qui a le meme id
	    debX = selectedNode.displayX;//e.pageX;
	    debY = selectedNode.displayY;//e.pageY;
  	}
  	  
    if (letsdraw === true) {
       ctx.clearRect(0, 0, dom.offsetWidth, dom.offsetHeight);
       ctx.beginPath();
       ctx.moveTo(debX, debY);
       ctx.lineTo(e.pageX, e.pageY);
       ctx.stroke();
    }
    
    
  }, false);
 
  sigInst.bind('overnodes', function (event) {
    // When we put the mouse cursor over nodes :
    //		- we highlight its interactions
    //		- we disable sigma mouse handler
    //		- we modify some custom mouse listener
    
    var nodes = event.content;
    sigInst.selectNodes(nodes);
    overNodeName = event.content[0];
    sigInst.mouseProperties({
		mouseEnabled: false
	});
	
	// Remove event listeners for outnodes
	$(window).off('mousedown', mouseDownOutnodes);
	$(window).off('mouseup', mouseUpOutnodes);
	
	// Add mouse down listener
	$(window).off('mousedown', mouseDownOvernodes);
	$(window).on('mousedown', mouseDownOvernodes);
	
	// Add mouse up listener
	$(window).off('mouseup', mouseUpOvernodes);
	$(window).on('mouseup', mouseUpOvernodes);
	
  }).bind('outnodes', function (event) {
    // When we put the mouse cursor outside nodes :
    //		- we deselect every node
    //		- we enable sigma mouse handler
    //		- we modify some custom mouse listener
    
    sigInst.deselectNodes();
    
    overNodeName = null;
	
	// Remove event listeners for overnodes
	$(window).off('mousedown', mouseDownOvernodes);
	$(window).off('mouseup', mouseUpOvernodes);
	
	// Add mouse down listener
	$(window).off('mousedown', mouseDownOutnodes);
	$(window).on('mousedown', mouseDownOutnodes);
	
	// Add mouse up listener
	$(window).off('mouseup', mouseUpOutnodes);
	$(window).on('mouseup', mouseUpOutnodes);
	
    sigInst.mouseProperties({
		mouseEnabled: true
	});
	
  }).bind('downgraph', function (event) {
    // When we click on the graph : we hide node info and do nothing else
    sigInst.hideNodeinfo(); // We change the graph color according to the selected node
  }).draw();
  /*** END : ACTIONS ON GRAPH EVENTS ***/

  /*** ACTIONS ON KEYBOARD EVENTS ***/
  $(window).keydown(function (e) {
    switch (e.keyCode) {
    case 27: // Escape
      sigInst.hideNodeinfo();
      break;
    }
  });
  /*** END : ACTIONS ON KEYBOARD EVENTS ***/
  
  /*** REFRESH NODES ***/
  document.onmousewheel = function (event) { // On mouse wheel...
    clearTimeout($.data(this, 'scrollTimer'));
    $.data(this, 'scrollTimer', setTimeout(function () {
      /* Function called after 250ms without scrolling. */
      sigInst.updateTypeNodeFilter();
    }, 250));
  };
  /*** END : REFRESH NODES ***/
 
};
