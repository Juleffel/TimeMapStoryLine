
function init() {
  var cerebro = document.getElementById('cerebro');
  if (cerebro == null) return;
  
  /**
   * This is the code to write the FishEye plugin :
   */
  
  (function(){
 
    // First, let's write a FishEye class.
    // There is no need to make this class global, since it is made to be used through
    // the SigmaPublic object, that's why a local scope is used for the declaration.
    // The parameter 'sig' represents a Sigma instance.
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
 
    sigma.publicPrototype.desactivateFishEye = function() {
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
 
  /**
   * Now, let's use our plugin :
   */
  var $cerebro = $(cerebro);
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
    maxRatio: 4,
    //mouseEnabled: false
  });
 
  // (requires "sigma.parseGexf.js" to be executed)
  var characters = $cerebro.data('characters');
  var characters_by_id = $cerebro.data('characters_by_id');
  var links = $cerebro.data('links');
  var links_by_id = $cerebro.data('links_by_id');
  
  for (var ch_ind in characters) {
    character = characters[ch_ind];
    console.log("Add character", character, character.id, character.name);
    sigInst.addNode('c'+character.id, {
      label: character.name,
      //x: Math.random(),
      //y: Math.random(),
      //size: 0.5+4.5*Math.random(),
      color: 'rgb(119,221,119)'
      //color: 'rgb('+Math.round(Math.random()*256)+','+
      //              Math.round(Math.random()*256)+','+
      //              Math.round(Math.random()*256)+')'
    });
  }
  
  for (var li_ind in links) {
    link = links[li_ind];
    console.log("Add link", link, link.id, link.from_character_id, link.to_character_id);
    sigInst.addEdge(
      'l'+link.id,
      'c'+link.from_character_id,
      'c'+link.to_character_id
    );
  }
  
  // Layout
  sigma.publicPrototype.myLayout = function() { 
    this.iterNodes(function(n){
      n.x = Math.random();
      n.y = Math.random();
    });
 
    return this.position(0,0,1).draw();
  };
  
  // Grey color for not selected nodes
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
 
  // Finally, let's activate the FishEye on our instance:
  sigInst.myLayout();
  sigInst.activateFishEye().draw();
  
  //document.onmousewheel = function(event){
  //	sigInst.desactivateFishEye()
  //}
}
 
if (document.addEventListener) {
  document.addEventListener('DOMContentLoaded', init, false);
} else {
  window.onload = init;
}