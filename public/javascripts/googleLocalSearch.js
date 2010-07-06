// Our global state
// These three variables are defined in globalMap.js: gLocalSearch, gMap, ginfowindow
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
  var hiddenLatLng = document.createElement("div");
  hiddenLatLng.className = "hiddenLatLng";
  hiddenLatLng.appendChild(document.createTextNode(parseFloat(me.result_.lat) ));
  hiddenLatLng.appendChild(document.createTextNode(", "));
  hiddenLatLng.appendChild(document.createTextNode(parseFloat(me.result_.lng) ));
  container.appendChild(hiddenLatLng);
  me.saveButton;
  return container;
}

LocalResult.prototype.saveButton = function() {
  var me = this;
  container = me.html;

  var button = document.createElement("input");
  button.type = "button";
  button.value = "Save park?";
  button.className = "addSuggestionFromSearch";
  container.appendChild(button);
}

LocalResult.prototype.highlight = function(highlight) {
  this.marker().setOptions({icon: highlight ? gRedIcon : gYellowIcon});
  this.node().className = "unselected" + (highlight ? " red" : "");
}

// I moved the on load functionality over to globalMap.js
// I'm not sure if this is the best plan.
//GSearch.setOnLoadCallback(OnLoad);

