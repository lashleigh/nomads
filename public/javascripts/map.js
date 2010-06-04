function initialize() {
  var latlng = new google.maps.LatLng(-34.397, 150.644);
  var myOptions = {
      zoom: 8,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  var image = 'http://farm5.static.flickr.com/4045/4645710826_aea797d107_s.jpg';
  var marker = new google.maps.Marker({
    position: latlng, 
    map: map, 
    icon: image,
  }) 
}

