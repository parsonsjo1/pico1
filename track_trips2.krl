ruleset track_trips2 {
  meta {
    name "Part 2: Track Trips"
    description <<
      Part 2
    >>
    author "Josh Parsons"
    logging on
    shares __testing
  }
  
  global {
    __testing = { "queries": [{ "name": "__testing" } ],
                  "events": [ { "domain": "car", "type": "new_trip",
                                "attrs": [ "mileage" ] } ]
                }

  }
  
  rule process_trip {
    select when car new_trip
    pre {
      mileage = event:attr("mileage")
    }
    send_directive("trip") with
      trip_length = mileage
    always {
      raise explicit event "trip_processed" 
        attributes event:attrs()
    }
  }
  
}