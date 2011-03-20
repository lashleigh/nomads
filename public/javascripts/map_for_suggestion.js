
$(function() {
  // Initialize the map with default UI.
  var sMap = new google.maps.Map(document.getElementById("map_canvas_for_suggestion"), {
    center: new google.maps.LatLng(suggestion.lat, suggestion.lon),
    zoom: 11,
    mapTypeId: 'roadmap'
  });

  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(suggestion.lat, suggestion.lon),
    map: sMap,
    title: suggestion.title,
    draggable: admin,
    icon: "/images/map_icons/"+suggestion.icon.name+".png",
  });
  google.maps.event.addListener(marker, 'dragend', function(evt) {
    suggestion.lat = evt.latLng.lat()
    suggestion.lon = evt.latLng.lng()
    suggestion.authenticity_token = $("meta[name=\"csrf-token\"]").attr("content")
    $.post("/suggestions/update_location", suggestion)
  });
});

