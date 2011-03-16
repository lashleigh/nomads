
$(function() {
  // Initialize the map with default UI.
  var postMap = new google.maps.Map(document.getElementById("map_canvas_for_post"), {
    center: new google.maps.LatLng(post.latitude, post.longitude),
    zoom: 7,
    mapTypeId: 'roadmap'
  });

  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(post.latitude, post.longitude),
    map: postMap,
    title: post.title,
    draggable: admin,
    icon: post.icon_path,
  });
  google.maps.event.addListener(marker, 'dragend', function(evt) {
    post.latitude = evt.latLng.lat()
    post.longitude = evt.latLng.lng()
    post.authenticity_token = $("meta[name=\"csrf-token\"]").attr("content")
    $.post("/posts/update_location", post)
  });
});

