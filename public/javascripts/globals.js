var gLocalSearch;
var gMap;
var gInfoWindow;

jQuery(function() {
  // Initialize the map with default UI.
  var center_lat = posts[0].latitude;
  var center_lon = posts[0].longitude;
  gMap = new google.maps.Map(document.getElementById("map_canvas"), {
    center: new google.maps.LatLng(center_lat, center_lon),
    zoom: 5,
    mapTypeId: 'roadmap'
  });

  // Create some fancy waypoint thingies
  draw_track();
  // Toggle full screen
  jQuery("#map_full_screen").click( function() {
    jQuery("#map_canvas").toggleClass("full_screen");
  });

  // Create one InfoWindow to open when a marker is clicked.
  gInfoWindow = new google.maps.InfoWindow({maxWidth: 240});
  google.maps.event.addListener(gInfoWindow, 'closeclick', function() {
    unselectMarkers();
  });

  // Initialize the local searcher
  gLocalSearch = new GlocalSearch();
  gLocalSearch.setSearchCompleteCallback(null, OnLocalSearch);

  // dosearch is the div id of the button
  jQuery("#clearsearch").click( function() {
      jQuery("#searchwell").html("");
      jQuery("#queryInput").val("");
      for (var i = 0; i < gCurrentResults.length; i++) {
        gCurrentResults[i].marker().setMap(null);
      }
  });
  jQuery("#queryInput").change(doSearch);
  jQuery("#dosearch").click(doSearch);
  jQuery(".addSuggestionFromSearch").live("click", function(e) {
    e.preventDefault();
    if(logged_in) {
      createSuggestionFromSearch(e);
    }
    else {
      jQuery(".message").html("<h3> Please <a href='/openid'> sign in</a> to make a suggestion. <a class='close_info' href=''>X</a></h3>").slideDown(600);
    }
  });

  jQuery(".icon_link").live("click", function(event) {
      var me = this;
      jQuery(".icon_link").removeClass("select");
      select(me); 
  });
});

function draw_track() {
  var track_points = jQuery(waypoints).map(function(i, p) { return new google.maps.LatLng(p[0], p[1]) }).get();
  var polyline = new google.maps.Polyline({
        path: track_points,
        strokeColor: "#FF6600",
        strokeOpacity: 1.0,
        strokeWeight: 2
      });
  polyline.setMap(gMap);
}

function select(me) {
  jQuery("#suggestion_icon_id").val(me.title);
  jQuery(me).addClass("select");
}

function createSuggestionFromSearch(event) {
  var parentdiv = $(".unselected").filter(".red")
  var suggestionLatLng = $(".hiddenLatLng").text().split(', ');
  var suggestedName = parentdiv.find("a.gs-title").text();
  jQuery.post("/map/new_suggestion",
             { lat: suggestionLatLng[0],
               lng: suggestionLatLng[1],
               title: suggestedName,
               authenticity_token: $("meta[name=\"csrf-token\"]").attr("content") },
             function(stuff) {
               jQuery.fancybox({ content: stuff, scrolling: "no" });
             });
}
