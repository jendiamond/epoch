$(document).ready(function() {
  $("#graph-btn").on("click", graph_update);
  $("#links-btn").on("click", links_update);

  return false;
});

function time_check() {
  // Check that the start time is before the end time
  var date  = $("#date_menu option:selected").text();
  var start = Math.floor( $("#start_menu").val() );
  var end   = Math.floor( $("#end_menu").val() );

  var values = [];
  if( start < end ) {
    values = [date, start, end];
  } else {
    var msg = "'Start Time' must be less then 'End Time'.\n";
    msg += "Please select correct times to continue.";
    alert( msg );

    console.log("start ", start, "end ", end);
  }

  return values;
}

function graph_update() {
  var values = time_check();
  if( values.length > 0 ) {
    console.log( "UPDATE GRAPH", values);

    // update graph with top 10 reps
  }
  return false;
}

function links_update() {
  // make sure the times are valid
  var values = time_check();
  if ( values.length > 0 ) {
    var data = {};
    data['date'] = values[0];
    data['start_time'] = values[1];
    data['end_time'] = values[2];

    $.ajax({
      type        : "GET",
      url         : '/refresh',
      data        : data,
      contentType : "application/json; charset=utf-8",
      dataType    : "json",
      complete    : function (r) {
        var items = r.responseJSON;

        // update links table
        if( items.length > 0 ) {
          // each item in the array is one row
          for (var i = 0; i < items.length; i++) {
            $("#r" + (i + 1) + "c2").html(items[i]['count']);
            $("#r" + (i + 1) + "c3").html(items[i]['name']);
            $("#r" + (i + 1) + "c4").html(items[i]['url']);
          }
        }
        return false;
      }
    });
  }

  return false;
}
