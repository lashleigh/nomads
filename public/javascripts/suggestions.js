jQuery(function() {
  // By using the same info window as the google search there will
  // only be one window open at a time.

  var bikeLayer = new google.maps.BicyclingLayer();
  bikeLayer.setMap(gMap);

  $(suggestions).each(post_or_suggestion); 
  $(posts).each(post_or_suggestion) 

  jQuery(images).each(function f(i, image) {
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(image.latitude, image.longitude),
      map: gMap,
      title: image.url,
      icon: "/images/map_icons/picture_icon.png"
    });
    google.maps.event.addListener(marker, 'click',
      function() { 
        gInfoWindow.setContent('<img border="0" style="height:auto; width: auto;" src="' + marker.title + '"/>')
        gInfoWindow.open(gMap,marker); 
      });
  });

  $(".close_info").live("click", function(e) {
      e.preventDefault(); 
      $(".message").slideUp(600);
      addingSuggestion = false;
  });
  var addingSuggestion = false;
  jQuery(".make_suggestion").click(function(e) {
    e.preventDefault();
    if(logged_in) {
      addingSuggestion = true;
      jQuery(".message").html("<h3> Please click on the map <a class='close_info' href=''>X</a> </h3>").slideDown(600);
    }
    else {
      addingSuggestion = false;
      jQuery(".message").html("<h3> Please <a href='/openid'> sign in</a> to make a suggestion. <a class='close_info' href=''>X</a></h3>").slideDown(600);
    }
  });

  // Hook into the form submission of any new suggestion, and 
  // send to the server via ajax instead.
  jQuery("#new_suggestion").live("submit", function(event) {
      var self = jQuery(this);
      jQuery.post(this.action, self.serialize(), function(res, text_status) {
        if(res.errors) {
          jQuery("#suggestion_errors").html('<ul><li>' + res.errors.join('</li><li>') + '</li></ul>').fadeIn(500);
          jQuery.fancybox.resize();
        }
        else {
          post_or_suggestion(0, res);
          jQuery.fancybox.close();
          $(".message").slideUp(600);
        }
      }, "json");
      return false;
  });

  google.maps.event.addListener(gMap, 'click', function(e) {
    if(addingSuggestion) {

      var p = e.latLng;
      jQuery.get("/map/new_suggestion", { lat: p.lat(), lng: p.lng() }, function(stuff) {
        jQuery.fancybox({ content: stuff, scrolling: "no" });
      });
    }
  }); 
});

function post_or_suggestion(i, ps) {
  console.log(ps);
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(ps.latitude, ps.longitude),
    map: gMap,
    title: ps.title,
    //draggable: true,
    icon: ps.icon_path,
  });
  google.maps.event.addListener(marker, 'click', function() { 
    gInfoWindow.setContent('<h3>'+ marker.title +'</h3>' + '<h4>' + ps.content + '</h4>' + '</br><h5>by ' + ps.user + '</h5>')
    gInfoWindow.open(gMap,marker); 
  });
}

