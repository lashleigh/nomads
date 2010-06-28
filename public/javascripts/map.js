$(function() {
  var options = {
    zoom: 14,
    center: new google.maps.LatLng(47.67, -122.38),
    mapTypeId: google.maps.MapTypeId.HYBRID
  };

  var map = new google.maps.Map($("#map_canvas")[0], options)
  for(var i in images) {
    function f() {
      var image = images[i]
      var marker = new google.maps.Marker({
        position: new google.maps.LatLng(image.latitude, image.longitude),
        map: map,
        title: image.url,
        draggable: true
      });
      google.maps.event.addListener(marker, 'dragend', function(evt) {
        image.latitude = evt.latLng.lat()
        image.longitude = evt.latLng.lng()
        $.post("/flickr/update_location", image)
        console.log("Finished dragging marker for image ", image)
      });
      marker.infowindow = new google.maps.InfoWindow;
      marker.infowindow.setContent('<img border="0" style="height:auto; width: auto;" src="' + marker.title + '"/>')
      google.maps.event.addListener(marker, 'mouseover', function() {
        marker.infowindow.open(map,marker);
      });
      google.maps.event.addListener(marker, 'mouseout', function() {
        setTimeout(function() { marker.infowindow.close(map,marker)}, 1000)
      });
    };
    f();
  }

  var bikeLayer = new google.maps.BicyclingLayer();
  bikeLayer.setMap(map);


  var addingSuggestion = false;
  $("#make_suggestion").click(function() {
    addingSuggestion = true;
    $("#make_suggestion").html("Click on the map to show us where your suggestion resides");
  });

  google.maps.event.addListener(map, 'click', function(e) {
    if(addingSuggestion) {
      $("#make_suggestion").html("make a suggestion");
      addingSuggestion = false;

      var p = e.latLng;
      $.get("/map/new_suggestion", { lat: p.lat(), lng: p.lng() }, function(stuff) {
        $.fancybox({ content: stuff, scrolling: "no" });
      });
    }
  }); 
});
