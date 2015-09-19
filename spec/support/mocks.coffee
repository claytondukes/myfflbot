class Msg
  send: ->

class Robot
  constructor: ->
    @responders = []
  http: ->
  respond: (regex, responderFunction) ->
    @responders.push {regex: regex, func: responderFunction}

  responderFor: (prompt) ->
    vals = r.func for r in @responders when prompt.match(r.regex)
    if typeof(vals) is "function"
      return vals
    if vals.length > 0 then vals[0] else undefined

  send: (prompt, msg) ->
    r.func(msg) for r in @responders when prompt.match(r.regex)

  logger:
    info: ->
    debug: ->
    error: ->

class Http
  constructor: (responseBody) ->
    @responseBody = responseBody
  header: -> this
  get: -> (callback) =>
    callback(null,null,@responseBody)

module.exports =
  Msg: Msg
  Http: Http
  Robot: Robot
