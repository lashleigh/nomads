
$(function() {
  // Initialize the map with default UI.
  var track_points = jQuery(waypoints).map(function(i, p) { return new google.maps.LatLng(p[0], p[1]) }).get();
  var current_lat = track_points[track_points.length - 1].lat()
  var current_lon = track_points[track_points.length - 1].lng()

  var waypointsMap = new google.maps.Map(document.getElementById("map_for_waypoints"), {
    center: new google.maps.LatLng(current_lat, current_lon),
    zoom: 7,
    mapTypeId: 'roadmap'
  });

  var polyline = new google.maps.Polyline({
        path: track_points,
        strokeColor: "#FF6600",
        strokeOpacity: 1.0,
        strokeWeight: 2
      });
  polyline.setMap(waypointsMap);
});

