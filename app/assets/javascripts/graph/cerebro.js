function init() {
	var cerebro = document.getElementById('js-graph');
	if (cerebro == null) return;
	
	/*** CEREBRO INSTANTIATION ***/
	//var defaultColor = 'rgb(119,221,119)';
	var $cerebro = $(cerebro);
	var sigInst = sigma.init(cerebro).drawingProperties({
		defaultLabelColor: '#fff',
		defaultLabelSize: 14,
		defaultLabelBGColor: '#fff',
		defaultLabelHoverColor: '#000',
		labelColor: "node",
		labelThreshold: 3,
		defaultEdgeType: 'curve'
	}).graphProperties({
		minNodeSize: 1,
		maxNodeSize: $cerebro.attr('max_node_size') || 10,
		minEdgeSize: 1,
		maxEdgeSize: $cerebro.attr('max_edge_size') || 2,
	}).mouseProperties({
		maxRatio: 5, // Max zoom
		minRatio: 1 // Max dezoom
	});
	sigInst.deselectColor = '#000';
	sigInst.focusedNode = null;
  sigInst.delayForceAtlas = 5;
  sigInst.defaultColor = '#fff';
	/*** END : CEREBRO INSTANTIATION ***/

	/*** LAUNCH MODULES ***/
	sigInst.loadData($cerebro);
  sigInst.deactivateFishEye();
	sigInst.circularLayout();
	sigInst.startForceAtlas2();
  sigInst.searchNode();
	sigInst.typeNodeFilter();
	sigInst.typeLinkFilter();
	sigInst.layoutButtons();
  sigInst.bindEvents();
  sigInst.nodeInfoLinksInit();
	/*** END : LAUNCH MODULES ***/
}

if (document.addEventListener) {
	document.addEventListener('DOMContentLoaded', init, false);
} else {
	window.onload = init;
}