
$(function() {
  // Initialize the map with default UI.
  var sMap = new google.maps.Map(document.getElementById("map_canvas_for_suggestion"), {
    center: new google.maps.LatLng(suggestion.latitude, suggestion.longitude),
    zoom: 7,
    mapTypeId: 'roadmap'
  });

  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(suggestion.latitude, suggestion.longitude),
    map: sMap,
    title: suggestion.title,
    draggable: (document.location.pathname.indexOf("edit") != -1),
    icon: suggestion.icon_path,
  });
  google.maps.event.addListener(marker, 'dragend', function(evt) {
    $("#suggestion_lat").val(evt.latLng.lat())
    $("#suggestion_lon").val(evt.latLng.lng())
  });
  $(".icon_link").live("click", function(event) {
      var me = this;
      $(".icon_link").removeClass("select");
      select(me); 
  });

});

function select(me) {
  $("#suggestion_icon_id").val(me.title);
  $(me).addClass("select");
}
