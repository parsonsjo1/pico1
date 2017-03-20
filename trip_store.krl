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

    trips = function() {
      ent:trips
    }

    long_trips = function() {
      ent:long_trips
    }

    short_trips = function() {
      //Return all trips in the trip entity that aren't in the long trip entity variable
      "Needs to be implemented"
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
      mileage = event:attr("mileage")
      timestamp = event:attr("timestamp")
    }
    always {
      ent:trips.put({"mileage": mileage, "timestamp": timestamp}).klog("JDP: TRIPS: ")
    }
  }

  rule collect_long_trips {
    select when explicit found_long_trip
    pre {
      mileage = event:attr("mileage")
      timestamp = event:attr("timestamp")
    }
    always {
      ent:long_trips.put({"mileage": mileage, "timestamp": timestamp})
    }
  }

  rule clear_trips {
    select when car trip_reset
    always {
      ent:trips := "";
      ent:long_trips := ""
    }
  }
  
}