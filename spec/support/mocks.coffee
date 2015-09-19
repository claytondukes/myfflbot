class Msg
  send: ->

class Robot
  constructor: ->
    @responders = []
    @https = []

  http: ->
    ret = @https.pop()
    ret

  expectHttpAndRespond: (opts) ->
    @https.splice(0, 0, new Http(opts))

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
  constructor: (opts) ->
    @responseBody = opts.body || null
    @responseErr = opts.err || null

  header: -> this

  get: -> (callback) =>
    callback(@responseErr,@response,@responseBody)

module.exports =
  Msg: Msg
  Http: Http
  Robot: Robot
