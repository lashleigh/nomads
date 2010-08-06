
$(function() {
  // Initialize the map with default UI.
  var sMap = new google.maps.Map(document.getElementById("map_canvas"), {
    center: new google.maps.LatLng(post.latitude, post.longitude),
    zoom: 7,
    mapTypeId: 'roadmap'
  });

  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(post.latitude, post.longitude),
    map: sMap,
    title: post.title,
    draggable: (document.location.pathname.indexOf("edit") != -1),
    icon: post.icon_path,
  });
  google.maps.event.addListener(marker, 'dragend', function(evt) {
    g("#post_lat").val(evt.latLng.lat())
    g("#post_lon").val(evt.latLng.lng())
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
