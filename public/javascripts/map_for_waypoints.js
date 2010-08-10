$(function() {
  // Initialize the map with default UI.
  var track_points = jQuery(waypoints).map(function(i, p) { return new google.maps.LatLng(p[0], p[1]) }).get();
  var current_lat = track_points[track_points.length - 1].lat()
  var current_lon = track_points[track_points.length - 1].lng()

  var waypointsMap = new google.maps.Map(document.getElementById("map_for_waypoints"), {
    center: new google.maps.LatLng(current_lat, current_lon),
    zoom: 5,
    mapTypeId: 'roadmap'
  });

  var polyline = new google.maps.Polyline({
        path: track_points,
        strokeColor: "#FF6600",
        strokeOpacity: 1.0,
        strokeWeight: 2
      });
  polyline.setMap(waypointsMap);

  $("#sortable_waypoints, #sortable_positions").sortable({
    connectWith: '.connectedSortable',
    placeholder: 'ui-state-highlight',
  });
  $("#sortable").disableSelection();

  $("#sortable_waypoints").sortable({
    receive: new_waypoint, 
    remove: remove_waypoint,
    start: start_sort,
    stop: stop_sort,
  });

  $("#sortable_positions").sortable( {
    receive: remove_waypoint,
  }
});

function new_waypoint(event) {
  something = event.originalEvent.target;
  position_as_string = something.id
  prev = something.previousElementSibling ? something.previousElementSibling.id : false
  next = something.nextElementSibling ? something.nextElementSibling.id : false
  $.post('/waypoint/new', {position_as_string: position_as_string, prev_waypoint_as_string: prev, next_waypoint_as_string: next} )
}

function remove_waypoint(event) {
  position_id = event.originalEvent.target.id.split("_")[1];
  $.post('/waypoint/destroy', {id: position_id});
}

function start_sort(event) {
  position_id = event.originalEvent.target.id.split("_")[1];
  $.post('/waypoint/start_sort', {id: position_id});
}

function stop_sort(event) {
  this_event = event;
  my_parent = this_event.target.id;
  if(my_parent == "sortable_waypoints") {
    something = event.originalEvent.target;
    position_as_string = something.id
    prev = something.previousElementSibling ? something.previousElementSibling.id : false
    next = something.nextElementSibling ? something.nextElementSibling.id : false
    $.post('/waypoint/stop_sort', {position_as_string: position_as_string, prev_waypoint_as_string: prev, next_waypoint_as_string: next} )
  }
  else {
    remove_waypoint(this_event); 
  }
}
