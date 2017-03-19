ruleset echo {
  meta {
    name "Echo Service"
    description <<
      Part one: Building a Simple Echo Service
    >>
    author "Josh Parsons"
    logging on
    shares __testing
  }
  
  global {
    __testing = { "queries": [{ "name": "__testing" } ],
                  "events": [ { "domain": "echo", "type": "hello" },
                              { "domain": "echo", "type": "message" },
                              { "attrs": [ "input" ] } ]
                }

  }
  
  rule hello {
    select when echo hello
    send_directive("say") with
      something = "Hello World"
  }

  rule message { 
    select when echo message
    pre {
      input = event:attr("input")
    }
    send_directive("say") with
      something = input
  }
  
}