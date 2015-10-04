Q       = require 'q'
Log     = require 'log'
logger  = new Log(process.env.HUBOT_LOG_LEVEL or 'info')

getHttpJson = (robot, url) ->
  logger.debug "Loading", url
  new Q.Promise (resolve, reject) ->
    robot.http(url)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        if err
          logger.error e
          reject err
        try
          logger.debug "resolving http request", body
          resolve(JSON.parse(body))
        catch e
          logger.error e
          reject e

module.exports =
  getHttpJson: getHttpJson
