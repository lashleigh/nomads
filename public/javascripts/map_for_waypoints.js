
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
  $("#sortable_waypoints").sortable({receive: function(event) {
    something = event.originalEvent.target;
    position_as_string = something.id
    prev_waypoint_as_string = something.previousElementSibling ? something.previousElementSibling.id : false
    next_waypoint_as_string = something.nextElementSibling ? something.nextElementSibling.id : false
    console.log(position_as_string, prev_waypoint_as_string, next_waypoint_as_string)
    $.post('/waypoint/new', {position_as_string: position_as_string, prev_waypoint_as_string: prev_waypoint_as_string, next_waypoint_as_string: next_waypoint_as_string})
  }});
});

