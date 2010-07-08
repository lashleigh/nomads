var gLocalSearch;
var gMap;
var gInfoWindow;

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
  jQuery("#new_suggestion").live("submit", function(event) {
      var self = jQuery(this);
      jQuery.post(this.action, this.serialize(), function(res, text_status) {
        new Suggestion(res);
        jQuery.fancybox.close();
      }, "json");
      return false;
  });
  jQuery(".icon_link").live("click", function(event) {
      var me = this;
      jQuery(".icon_link").removeClass("select");
      select(me); 
  });
});

function select(me) {
  jQuery("#suggestion_icon_id").val(me.title);
  me.addClassName("select");
}

function createSuggestionFromSearch(event) {
  var parentdiv = jQuery(this).parents(".unselected")
  var suggestionLatLng = parentdiv.find(".hiddenLatLng").text().split(', ');
  var suggestedName = parentdiv.find("a.gs-title").text();
  jQuery.get("/map/new_suggestion", { lat: suggestionLatLng[0], lng: suggestionLatLng[1], name: suggestedName }, function(stuff) {
    jQuery.fancybox({ content: stuff, scrolling: "no" });
  });
}
