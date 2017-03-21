ruleset trip_store {
  meta {
    name "Part 3: Trip Store"
    description <<
      Part 3
    >>
    author "Josh Parsons"
    logging on
    provides trips, long_trips, short_trips
    shares trips, long_trips, short_trips, __testing
  }
  
  global {

    clear_trip = []

    trips = function() {
      ent:trips
    }

    long_trips = function() {
      ent:long_trips
    }

    short_trips = function() {
      //Return all trips in the trip entity that aren't in the long trip entity variable
      ent:trips.filter(function(x){x<101})
    }

    __testing = { "queries": [{ "name": "__testing" },
                              { "name": "trips" },
                              { "name": "long_trips" },
                              { "name": "short_trips" } ],
                  "events": [ { "domain": "car", "type": "trip_reset" } ]
                }

  }

  rule collect_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").klog("mileage received ")
      timestamp = event:attr("timestamp").klog("timestamp received ")
    }
    always {
      ent:trips := ent:trips.append([{"mileage": mileage, "timestamp": timestamp}]).klog("JDP: TRIPS: ")
    }
  }

  rule collect_long_trips {
    select when explicit found_long_trip
    pre {
      mileage = event:attr("mileage")
      timestamp = event:attr("timestamp")
    }
    always {
      ent:long_trips := ent:long_trips.append([{"mileage": mileage, "timestamp": timestamp}])
    }
  }

  rule clear_trips {
    select when car trip_reset
    always {
      ent:trips := clear_trip;
      ent:long_trips := clear_trip
    }
  }
  
}