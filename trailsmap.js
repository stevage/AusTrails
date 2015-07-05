function bookmark(bm) {
  bookmarks={ 
    "adelaide": { x: 138.6217, y: -34.9491, z: 13 },
    "melbourne": { x: 144.95, y: -37.8, z: 11 },
    "manningham": { x: 145.15, y: -37.77, z: 13},
    "geelong": { x: 144.5, y: -38.15, z: 11},
    "ballarat": { x: 143.83, y: -37.56, z: 12},
    "colac-otways": { x: 143.61, y: -38.4, z: 10},
    "corangamite": { x: 143.1, y: -38.3, z: 10},
    "waite": { x: 138.63, y: -34.97, z: 16 },
    "wyndham": { x: 144.62, y: -37.92, z: 12 }

  };
  if (b = bookmarks[bm]) {
    map.setView(L.latLng(b.y,b.x), b.z);
  }
}

function doBookmarks() {
    var matches = window.location.href.match(/#([a-zA-Z0-9_-]+)/);
    if (matches) {
      bookmark(matches[1]);
    }
  
}

if (window.location.href.match("embed")) {
  // cut down some chrome for embedding
  $("#header").hide();
  $("#logo").hide();
  $("#map").css("height","100%");
}


var base = "http://trails.cycletour.org:5044/",
    mapName = "trails";
    
var map;    
var updated = 'updated=47';
$.getJSON(base + mapName + ".json?" + updated, {}, function(tilejson) {
  tilejson.grids[0] = 'http://trails.cycletour.org/tile/trails/{z}/{x}/{y}.grid.json?metatile=4&' + updated;
  tilejson.tiles[0] = 'http://trails.cycletour.org/tile/trails/{z}/{x}/{y}.png?' + updated;
  tilejson.maxzoom = 22;
  tilejson.minzoom = 8;
  tilejson.template = '{{#__teaser__}}' +
  '<b>{{{name}}}</b> <br/> ' + 
  '<i>{{{description}}}</i><br/>' +
  '{{#photo}}' + 
  '<img src="http://austrails.org/datasources/greattrails_images/{{{photo}}}"/>' + 
  '{{/photo}}' + 
  'Source: {{{source}}}' +
  '{{/__teaser__}}' + 

  '{{#__full__}}' + 

  '<b>{{{name}}}</b> <br/> ' + 
  '<i>{{{description}}}</i><br/>' +
  '{{#photo}}' + 
  '<img src="http://austrails.org/datasources/greattrails_images/{{{photo}}}"/>' + 
  '{{/photo}}' + 
  '<strong>' +
  '<a target="_blank" href="https://docs.google.com/forms/d/1NW6yNNlvDBns9FI7gkMZfPqG8HxfpjfbwgeEzpCz2Yw/viewform?entry.601845213={{{pid}}}&entry.767249504">' +
  ' Leave feedback</a>' +
  '</strong>' +
  "<br/>" + 
  'Source: <a target="_blank" href="{{{sourceurl}}}">{{{source}}}</a>' +


  '{{/__full__}}'

  ;
  delete tilejson.bounds;
  var cycletourbase = L.tileLayer("http://{s}.cycletour.org/cycletour/{z}/{x}/{y}.png?updated=2");

  var vicmapbase = L.tileLayer.wms('http://api.maps.vic.gov.au/geowebcacheWM/service/wms?VERSION=1.1.1&TILED=true',
            {
              attribution:'Victorian Government',
              layers: 'WEB_MERCATOR',
              format: 'image/png',
              transparent: false,
              continuousWorld: true,
              detectRetina: false//true
            });

  
  map = L.mapbox.map('map',undefined).setView([-37,145],8);
  cycletourbase.addTo(map);
  var trailsoverlay = L.mapbox.tileLayer(tilejson);
  var trailgrid = L.mapbox.gridLayer(tilejson);
  var myGridControl = L.mapbox.gridControl(trailgrid).addTo(map);
  myGridControl.addTo(map);
  trailgrid.addTo(map);
  trailsoverlay.addTo(map);
  L.control.layers(
    { "Cycling and hiking": cycletourbase, 'VicMap': vicmapbase }, {  "Trails": trailsoverlay}, /*{ "OpenStreetMap trees": osmtrees, "Interesting trees": interestingtrees},*/
    //{},
    { "collapsed": true, position: "bottomright" }
    ).addTo(map);
  //map.setView(L.latLng(-38, 144), 9);
  doBookmarks();

});



$(function() {

    currentstate = $("#vicrts");

var popup = L.popup();


function showState(statediv) {
    currentstate.hide();
    currentstate = statediv;
    currentstate.show();
}

//map.on('click', onMapClick);


$("#vicrt").on('click', function() { showState($("#vicrts"));  });
$("#vicgt").on('click', function() { showState($("#vicgts"));  });


$(".trailslist a").on('click', function() { 
    //console.log($(this).data("loc"));
    loc = JSON.parse("[" + $(this).data("loc") + "]");
    map.setView(loc.slice(0,2), loc[2]);
});

$(".trailslist a").each(function( index ) {
    this.href = "#" + this.id;
    
    this.id="a-" + this.id;
});

var anchor = window.location.href.substring((window.location.href+"#").indexOf("#")+1,1000);
// quick kludge to make anchors not scroll.
if (anchor != "") {
    //console.log("Going to ")
    $("#a-" + anchor).click();
}

});
