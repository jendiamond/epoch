$(document).ready(function() {
  $("#graph-btn").on("click", graph_update );
  $("#links-btn").on("click", links_update );

  // Autoload the graph on reports page
  var current = window.location.pathname;
  if(current == "/reports" ) {
    graph_update();
  }

  return false;
});

function time_check() {
  // Check that the start time is before the end time
  var event = $("#event_menu option:selected").text();
  var date  = $("#date_menu option:selected").text();
  var start = Math.floor( $("#start_menu").val() );
  var end   = Math.floor( $("#end_menu").val() );

  if( start < end ) {
    return [event, date, start, end];
  } else {
    var msg = "'Start Time' must be less then 'End Time'.\n";
    msg += "Please select correct times to continue.";
    alert( msg );
    console.log("start ", start, "end ", end);
    return [];
  }
}

function graph_update() {
  var values = time_check();
  if( values.length > 0 ) {

    var data = {};
    data['event'] = values[0];
    data['date'] = values[1];
    data['start_time'] = values[2];
    data['end_time'] = values[3];

    $.ajax({
      type        : "GET",
      url         : '/redraw',
      data        : data,
      contentType : "application/json; charset=utf-8",
      dataType    : "json",
      complete    : function (r) {
        var items = r.responseJSON;

        // update graph with top 10 reps
        var chart = AmCharts.makeChart("chartdiv", {
          "theme": "none",
          "type": "serial",
          "startDuration": 2,
          "dataProvider": items,
          "valueAxes": [{
            "position": "left",
            "title": "Counts"
          }],
          "graphs": [{
            "balloonText": "[[category]]: <b>[[value]]</b>",
            "colorField": "color",
            "fillAlphas": 1,
            "lineAlpha": 0.1,
            "type": "column",
            "valueField": "count"
          }],
          "depth3D": 20,
          "angle": 30,
          "chartCursor": {
            "categoryBalloonEnabled": false,
            "cursorAlpha": 0,
            "zoomable": false
          },
          "categoryField": "name",
          "categoryAxis": {
            "gridPosition": "start",
            "labelRotation": 90
          }
        });

        return false;
      }
    });

  }
  return false;
}

function links_update() {
  // make sure the times are valid
  var values = time_check();
  if ( values.length > 0 ) {
    var data = {};
    data['event'] = values[0];
    data['date'] = values[1];
    data['start_time'] = values[2];
    data['end_time'] = values[3];

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

