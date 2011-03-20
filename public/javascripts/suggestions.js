var waypoint_array = []
var marker_hash = []
jQuery(function() {
  // By using the same info window as the google search there will
  // only be one window open at a time.
  $("#sub_header_icons li").live("click", function() {
   if( $(this).hasClass("selected")) {
     $(this).removeClass("selected");
     hide_type($(this).find("img").attr("title"));
   } else {
     $(this).addClass("selected");
     show_type($(this).find("img").attr("title"));
   }
  });

  var bikeLayer = new google.maps.BicyclingLayer();
  bikeLayer.setMap(gMap);

  for(val in sug_hash) {display_suggestion(val)}
  marker_hash["blog"] = []
  marker_hash["image"] = []
  $(posts).each(display_post) 

  jQuery(images).each(function f(i, im) {
    var image = im.flickr_photo;
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(image.lat, image.lon),
      map: gMap,
      title: image.url,
      icon: "/images/map_icons/image.png"
    });
    marker_hash["image"].push(marker);
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
          console.log(res);
          individual_suggestion(res.suggestion, res.suggestion.icon.name);
          jQuery.fancybox.close();
          addingSuggestion = false;
          $(".message").slideUp(600);
        }
      }, "json");
      return false;
  });

  google.maps.event.addListener(gMap, 'click', function(e) {
    if(addingSuggestion) {

      var p = e.latLng;
      jQuery.post("/map/new_suggestion", { 
        lat: p.lat(), 
        lng: p.lng(),
        authenticity_token: $("meta[name=\"csrf-token\"]").attr("content")
      }, function(stuff) {
        jQuery.fancybox({ content: stuff, scrolling: "no" });
      });
    }
  }); 
});

function display_suggestion(ps) {
  var sugs = sug_hash[ps];
  marker_hash[ps] = [];
  for( i = 0; i < sugs.length; i++) {
    individual_suggestion(sugs[i], ps);
  }
}
function individual_suggestion(sug, ps) {
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(sug.lat, sug.lon),
    map: gMap,
    title: sug.title,
    icon: "images/map_icons/"+ps+".png",
  });
  marker_hash[ps].push(marker);
  google.maps.event.addListener(marker, 'click', function() { 
    gInfoWindow.setContent('<h3><a href="/suggestions/'+sug.to_param+'">'+marker.title+'</a></h3>'+sug.shorten+'<h5>by <a href="/users/'+sug.user.to_param+'">'+sug.user.display_name+'</a></h5>')
    gInfoWindow.open(gMap,marker); 
  });
}
function hide_type(type) {
  for(i in marker_hash[type]) {
    marker_hash[type][i].setMap(null);
  }
}
function show_type(type) {
  for(i in marker_hash[type]) {
    marker_hash[type][i].setMap(gMap);
  }
}
function display_post(i, ps) {
  var post = ps.post;
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(post.lat, post.lon),
    map: gMap,
    title: post.title,
    icon: "/images/map_icons/blog.png",
  });
  marker_hash["blog"].push(marker);
  google.maps.event.addListener(marker, 'click', function() { 
    gInfoWindow.setContent('<h3><a href="/posts/'+post.to_param+'">'+marker.title+'</a></h3>'+post.short_content+'<h5>by <a href="/users/'+post.user.to_param+'">'+post.user.display_name+'</a></h5>')
    gInfoWindow.open(gMap,marker); 
  });
}
