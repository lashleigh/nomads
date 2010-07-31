
jQuery(function() {
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
    console.log(evt);
    $("#post_lat").val(evt.latLng.lat())
    $("#post_lon").val(evt.latLng.lng())
  });
  jQuery(".icon_link").live("click", function(event) {
      var me = this;
      jQuery(".icon_link").removeClass("select");
      select(me); 
  });

});

function select(me) {
  jQuery("#suggestion_icon_id").val(me.title);
  jQuery(me).addClass("select");
}
