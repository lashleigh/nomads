
$(function() {
  // Initialize the map with default UI.
  var postMap = new google.maps.Map(document.getElementById("map_canvas_for_post"), {
    center: new google.maps.LatLng(post.lat, post.lon),
    zoom: 11,
    mapTypeId: 'roadmap'
  });

  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(post.lat, post.lon),
    map: postMap,
    title: post.title,
    draggable: admin,
    icon: "/images/map_icons/blog.png",
  });
  google.maps.event.addListener(marker, 'dragend', function(evt) {
    post.lat = evt.latLng.lat()
    post.lon = evt.latLng.lng()
    post.authenticity_token = $("meta[name=\"csrf-token\"]").attr("content")
    $.post("/posts/update_location", post)
  });
});

