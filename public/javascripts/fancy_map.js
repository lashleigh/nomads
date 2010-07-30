jQuery(function() {
  var lat = $("#suggestion_lat").val();
  var lon = $("#suggestion_lon").val();
  var fancyMap = new google.maps.Map(document.getElementById("fancy_map"), {
    center: new google.maps.LatLng(lat, lon),
    zoom: 14,
    mapTypeId: 'roadmap',
    navigationControl: false,
    mapTypeControl: false,
  });

  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(lat, lon),
    map: fancyMap,
    draggable: true,
  });
  google.maps.event.addListener(marker, 'dragend', function(evt) {
    $("#suggestion_lat").val(evt.latLng.lat())
    $("#suggestion_lon").val(evt.latLng.lng())
    lat = $("#suggestion_lat").val();
    lon = $("#suggestion_lon").val();
    console.log(lat, lon);
    //jQuery.post("/posts/update_location", post)
  });

});

