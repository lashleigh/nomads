    // Our global state
    var gLocalSearch;
    var gMap;
    var gInfoWindow;
    var gSelectedResults = [];
    var gCurrentResults = [];
    var gSearchForm;

    // Create our "tiny" marker icon
    var gYellowIcon = new google.maps.MarkerImage(
      "http://labs.google.com/ridefinder/images/mm_20_yellow.png",
      new google.maps.Size(12, 20),
      new google.maps.Point(0, 0),
      new google.maps.Point(6, 20));
    var gRedIcon = new google.maps.MarkerImage(
      "http://labs.google.com/ridefinder/images/mm_20_red.png",
      new google.maps.Size(12, 20),
      new google.maps.Point(0, 0),
      new google.maps.Point(6, 20));
    var gSmallShadow = new google.maps.MarkerImage(
      "http://labs.google.com/ridefinder/images/mm_20_shadow.png",
      new google.maps.Size(22, 20),
      new google.maps.Point(0, 0),
      new google.maps.Point(6, 20));

     // Set up the map and the local searcher.
    function OnLoad() {

      // Initialize the map with default UI.
      gMap = new google.maps.Map(document.getElementById("map_canvas"), {
        center: new google.maps.LatLng(47.67, -122.38),
        zoom: 13,
        mapTypeId: 'hybrid'
      });
      // Create one InfoWindow to open when a marker is clicked.
      gInfoWindow = new google.maps.InfoWindow;
      google.maps.event.addListener(gInfoWindow, 'closeclick', function() {
        unselectMarkers();
      });

      // Initialize the local searcher
      gLocalSearch = new GlocalSearch();
      gLocalSearch.setSearchCompleteCallback(null, OnLocalSearch);

      $(suggestions).each(function(i, suggestion) {
        var marker = new google.maps.Marker({
          position: new google.maps.LatLng(suggestion.latitude, suggestion.longitude),
          map: gMap,
          title: suggestion.name,
        });
        marker.infowindow = new google.maps.InfoWindow;
        marker.infowindow.setContent("<h3>" + suggestion.name + "</h3><p>" + suggestion.content + "</p>");
        google.maps.event.addListener(marker, 'click',
          function() { marker.infowindow.open(gMap, marker) });
      });
  
      var bikeLayer = new google.maps.BicyclingLayer();
      bikeLayer.setMap(gMap);
  
      var addingSuggestion = false;
      $("#make_suggestion").click(function() {
        addingSuggestion = true;
        $("#make_suggestion").html("Click on the map to show us where your suggestion resides");
      });
  
      google.maps.event.addListener(gMap, 'click', function(e) {
        if(addingSuggestion) {
          $("#make_suggestion").html("make a suggestion");
          addingSuggestion = false;
  
          var p = e.latLng;
          $.get("/map/new_suggestion", { lat: p.lat(), lng: p.lng() }, function(stuff) {
            $.fancybox({ content: stuff, scrolling: "no" });
          });
        }
      }); 
      $(images).each(function f(i, image) {
        var marker = new google.maps.Marker({
          position: new google.maps.LatLng(image.latitude, image.longitude),
          map: gMap,
          title: image.url,
          draggable: true,
          icon: "/images/map_icons/picture_icon.png"
        });
        google.maps.event.addListener(marker, 'dragend', function(evt) {
          image.latitude = evt.latLng.lat()
          image.longitude = evt.latLng.lng()
          $.post("/flickr/update_location", image)
          console.log("Finished dragging marker for image ", image)
        });
        marker.infowindow = new google.maps.InfoWindow;
        marker.infowindow.setContent('<img border="0" style="height:auto; width: auto;" src="' + marker.title + '"/>')
        google.maps.event.addListener(marker, 'mouseover',
          function() { marker.infowindow.open(gMap,marker); });
        google.maps.event.addListener(marker, 'mouseout', function() {
          setTimeout(function() { marker.infowindow.close(gMap,marker)}, 1000)
        });
      });
    }

    function unselectMarkers() {
      for (var i = 0; i < gCurrentResults.length; i++) {
        gCurrentResults[i].unselect();
      }
    }

    function doSearch() {
      var query = document.getElementById("queryInput").value;
      gLocalSearch.setCenterPoint(gMap.getCenter());
      gLocalSearch.execute(query);
    }
    $("#submitSearch").click(doSearch)

    // Called when Local Search results are returned, we clear the old
    // results and load the new ones.
    function OnLocalSearch() {
      if (!gLocalSearch.results) return;
      var searchWell = document.getElementById("searchwell");

      // Clear the map and the old search well
      searchWell.innerHTML = "";
      for (var i = 0; i < gCurrentResults.length; i++) {
        gCurrentResults[i].marker().setMap(null);
      }
      // Close the infowindow
      gInfoWindow.close();

      gCurrentResults = [];
      for (var i = 0; i < gLocalSearch.results.length; i++) {
        gCurrentResults.push(new LocalResult(gLocalSearch.results[i]));
      }

      var attribution = gLocalSearch.getAttribution();
      if (attribution) {
        document.getElementById("searchwell").appendChild(attribution);
      }

      // Move the map to the first result
      var first = gLocalSearch.results[0];
      gMap.setCenter(new google.maps.LatLng(parseFloat(first.lat),
                                            parseFloat(first.lng)));

    }

    // Cancel the form submission, executing an AJAX Search API search.
    function CaptureForm(searchForm) {
      gLocalSearch.execute(searchForm.input.value);
      return false;
    }



    // A class representing a single Local Search result returned by the
    // Google AJAX Search API.
    function LocalResult(result) {
      var me = this;
      me.result_ = result;
      me.resultNode_ = me.node();
      me.marker_ = me.marker();
      google.maps.event.addDomListener(me.resultNode_, 'mouseover', function() {
        // Highlight the marker and result icon when the result is
        // mouseovered.  Do not remove any other highlighting at this time.
        me.highlight(true);
      });
      google.maps.event.addDomListener(me.resultNode_, 'mouseout', function() {
        // Remove highlighting unless this marker is selected (the info
        // window is open).
        if (!me.selected_) me.highlight(false);
      });
      google.maps.event.addDomListener(me.resultNode_, 'click', function() {
        me.select();
      });
      document.getElementById("searchwell").appendChild(me.resultNode_);
    }

    LocalResult.prototype.node = function() {
      if (this.resultNode_) return this.resultNode_;
      return this.html();
    };

    // Returns the GMap marker for this result, creating it with the given
    // icon if it has not already been created.
    LocalResult.prototype.marker = function() {
      var me = this;
      if (me.marker_) return me.marker_;
      var marker = me.marker_ = new google.maps.Marker({
        position: new google.maps.LatLng(parseFloat(me.result_.lat),
                                         parseFloat(me.result_.lng)),
        icon: gYellowIcon, shadow: gSmallShadow, map: gMap});
      google.maps.event.addListener(marker, "click", function() {
        me.select();
      });
      return marker;
    };

    // Unselect any selected markers and then highlight this result and
    // display the info window on it.
    LocalResult.prototype.select = function() {
      unselectMarkers();
      this.selected_ = true;
      this.highlight(true);
      gInfoWindow.setContent(this.html(true));
      gInfoWindow.open(gMap, this.marker());
    };

    LocalResult.prototype.isSelected = function() {
      return this.selected_;
    };

    // Remove any highlighting on this result.
    LocalResult.prototype.unselect = function() {
      this.selected_ = false;
      this.highlight(false);
    };

    // Returns the HTML we display for a result before it has been "saved"
    LocalResult.prototype.html = function() {
      var me = this;
      var container = document.createElement("div");
      container.className = "unselected";
      container.appendChild(me.result_.html.cloneNode(true));
      return container;
    }

    LocalResult.prototype.highlight = function(highlight) {
      this.marker().setOptions({icon: highlight ? gRedIcon : gYellowIcon});
      this.node().className = "unselected" + (highlight ? " red" : "");
    }

    GSearch.setOnLoadCallback(OnLoad);
    //]]>
 
