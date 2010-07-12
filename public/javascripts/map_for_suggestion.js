
jQuery(function() {
  // Initialize the map with default UI.
  var sMap = new google.maps.Map(document.getElementById("map_canvas"), {
    center: new google.maps.LatLng(suggestion.latitude, suggestion.longitude),
    zoom: 7,
    mapTypeId: 'roadmap'
  });

  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(suggestion.latitude, suggestion.longitude),
    map: sMap,
    title: suggestion.title,
    draggable: true,
    icon: suggestion.icon_path,
  });
  google.maps.event.addListener(marker, 'dragend', function(evt) {
    suggestion.latitude = evt.latLng.lat()
    suggestion.longitude = evt.latLng.lng()
    jQuery.post("/suggestions/update_location", suggestion)
  });
  jQuery(".icon_link").live("click", function(event) {
      var me = this;
      jQuery(".icon_link").removeClass("select");
      select(me); 
  });

});

function select(me) {
  jQuery("#suggestion_icon_id").val(me.title);
  me.addClassName("select");
}


