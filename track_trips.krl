ruleset track_trips {
  meta {
    name "Echo Service: Track Trips"
    description <<
      Part one: Building a Simple Echo Service
    >>
    author "Josh Parsons"
    logging on
    shares __testing
  }
  
  global {
    __testing = { "queries": [{ "name": "__testing" } ],
                  "events": [ { "domain": "echo", "type": "message",
                                "attrs": [ "mileage" ] } ]
                }

  }
  
  rule process_trip {
    select when echo message
    pre {
      mileage = event:attr("mileage")
    }
    send_directive("trip") with
      trip_length = mileage
  }
  
}