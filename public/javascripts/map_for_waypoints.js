var waypointsMap;
var current_lat;
var current_lon;
var polyline;

$(function() {
  // Initialize the map with default UI.
  var track_points = jQuery(waypoints).map(function(i, p) { return new google.maps.LatLng(p[0], p[1]) }).get();
  current_lat = track_points[track_points.length - 2].lat()
  current_lon = track_points[track_points.length - 2].lng()

  waypointsMap = new google.maps.Map(document.getElementById("map_for_waypoints"), {
    center: new google.maps.LatLng(current_lat, current_lon),
    zoom: 6,
    mapTypeId: 'roadmap'
  });
  draw_track();

  $("#sortable_waypoints, #sortable_positions").sortable({
    connectWith: '.connectedSortable',
    placeholder: 'ui-state-highlight',
  });
  $("#sortable").disableSelection();

  $("#sortable_waypoints").sortable({
    receive: new_waypoint, 
    remove: remove_waypoint,
  });

});

function draw_track() {
  if(polyline) { polyline.setMap(null) };
  var track_points = jQuery(waypoints).map(function(i, p) { return new google.maps.LatLng(p[0], p[1]) }).get();
  current_lat = track_points[track_points.length - 1].lat()
  current_lon = track_points[track_points.length - 1].lng()

  polyline = new google.maps.Polyline({
        path: track_points,
        strokeColor: "#FF6600",
        strokeOpacity: 1.0,
        strokeWeight: 2
      });
  polyline.setMap(waypointsMap);
}

function delegate(event) {
  something = event.target.id;
  if(something == "sortable_waypoints") { update_waypoints(event) }
}

function new_waypoint(event) {
  something = event.originalEvent.target;
  position_as_string = something.id
  prev = something.previousElementSibling ? something.previousElementSibling.id : false
  next = something.nextElementSibling ? something.nextElementSibling.id : false
  $.post('/waypoints/new', {position_as_string: position_as_string, prev_waypoint_as_string: prev, next_waypoint_as_string: next} )
  draw_track();
}

function remove_waypoint(event) {
  position_id = event.originalEvent.target.id.split("_")[1];
  $.post('/waypoints/destroy', {id: position_id});
}

function update_waypoints(event) {
  something = event.originalEvent.target
  position_id = something.id.split("_")[1];
  prev = something.previousElementSibling ? something.previousElementSibling.id : false
  next = something.nextElementSibling ? something.nextElementSibling.id : false
  $.post('/waypoints/update_waypoints', {id: position_id, prev_waypoint_as_string: prev, next_waypoint_as_string: next} )
  draw_track();
}
