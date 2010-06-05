var geocoder;
var map;
var infowindow = new google.maps.InfoWindow();
function initialize() {
  geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(-34.397, 150.644);
  var myOptions = {
      zoom: 8,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  google.maps.event.addListener(map, 'click', function(event) {
    placeMarker(event.latLng);
  }); 
  google.maps.event.addListener(google.maps.Marker, 'dblclick', function(event) {
    removeMarker(google.maps.Marker);
  }); 
}
function removeMarker(marker) {
  marker.setMap(null)
}
function placeMarker(location) {
  var clickedLocation = new google.maps.LatLng(location);
  var marker = new google.maps.Marker({
    position: location,
    map: map,
    draggable: true,
    clickable: true,
  });
  
  map.setCenter(location);
} 

function addImage() {
  var image = 'http://farm5.static.flickr.com/4045/4645710826_aea797d107_s.jpg';
  var marker = new google.maps.Marker({
    position: latlng, 
    map: map, 
    icon: image,
    draggable: true,
  }) 
}

function codeLatLng() {
  var input = document.getElementById("latlng").value;
  var latlngStr = input.split(",",2);
  var lat = parseFloat(latlngStr[0]);
  var lng = parseFloat(latlngStr[1]);
  var latlng = new google.maps.LatLng(lat, lng);
  if (geocoder) {
    geocoder.geocode({'latLng': latlng}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
        if (results[1]) {
        map.setZoom(11);
        marker = new google.maps.Marker({
          position: latlng, 
          map: map,
        }); 
        infowindow.setContent(results[1].formatted_address);
        infowindow.open(map, marker);
      }
    } else {
       alert("Geocoder failed due to: " + status);
    }
  });
  }
}

function codeAddress() {
  var address = document.getElementById("address").value;
  if (geocoder) {
    geocoder.geocode( { 'address': address}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
        var marker = new google.maps.Marker({
          map: map, 
          position: results[0].geometry.location
          });
        } else {
          alert("Geocode was not successful for the following reason: " + status);
        }
    });
  }
}

