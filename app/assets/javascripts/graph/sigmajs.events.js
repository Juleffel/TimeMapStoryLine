sigma.publicPrototype.bindEvents = function () {
  var sigInst = this;
  /*** ACTIONS ON GRAPH EVENTS ***/
  sigInst.bind('overnodes', function (event) { // When we put the mouse cursor over nodes...
    var nodes = event.content;
    sigInst.selectNodes(nodes);
  }).bind('outnodes', function (event) { // ... when we remove the mouse cursor...
    sigInst.deselectNodes();
  }).bind('downgraph', function (event) { // ... and when we click on the graph
    sigInst.hideNodeinfo(); // We change the graph color according to the selected node
  }).bind('downnodes', function (event) {
    sigInst.hideNodeinfo();
    sigInst.showNodeinfo(event.content[0]);
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
