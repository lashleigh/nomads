jQuery(function() {
  var fancyMap = new google.maps.Map(document.getElementById("fancy_map"), {
    center: new google.maps.LatLng(47.6543, -122.2634),
    zoom: 10,
    mapTypeId: 'roadmap',
    scrollwheel: false,
    keyboardShortcuts: false,
    navigationControl: false,
    mapTypeControl: false,
    disableDoubleClickZoom: true,
  });
});
