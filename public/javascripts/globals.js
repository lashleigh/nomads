var gLocalSearch;
var gMap;
var gInfoWindow;
var iconId = 1;

jQuery(function() {
  // Initialize the map with default UI.
  gMap = new google.maps.Map(document.getElementById("map_canvas"), {
    center: new google.maps.LatLng(47.6543, -122.2634),
    zoom: 10,
    mapTypeId: 'roadmap'
  });
  
  // Create one InfoWindow to open when a marker is clicked.
  gInfoWindow = new google.maps.InfoWindow;
  google.maps.event.addListener(gInfoWindow, 'closeclick', function() {
    unselectMarkers();
  });

  // Initialize the local searcher
  gLocalSearch = new GlocalSearch();
  gLocalSearch.setSearchCompleteCallback(null, OnLocalSearch);

  // dosearch is the div id of the button
  jQuery("#dosearch").click(doSearch);
  jQuery(".addSuggestionFromSearch").live("click", createSuggestionFromSearch);
  jQuery(".icon_link").live("click", function(event) {
      jQuery(".icon_link").removeClass("select");
      select(event); 
  });
});

function select(event) {
  path = event.currentTarget;
  iconId = path.title;
  console.log(iconId);
  path.addClassName("select");
}

function createSuggestionFromSearch(event) {
  var parentdiv = jQuery(this).parents(".unselected")
  var suggestionLatLng = parentdiv.find(".hiddenLatLng").text().split(', ');
  var suggestedName = parentdiv.find("a.gs-title").text();
  jQuery.get("/map/new_suggestion", { lat: suggestionLatLng[0], lng: suggestionLatLng[1], name: suggestedName, icon_id: iconId }, function(stuff) {
    jQuery.fancybox({ content: stuff, scrolling: "no" });
  });
}
