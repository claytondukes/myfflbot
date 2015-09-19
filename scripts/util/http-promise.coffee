Promise = require 'promise'
Log     = require 'log'
logger  = new Log(process.env.HUBOT_LOG_LEVEL or 'info')

getHttpJson = (robot, url) ->
  new Promise (resolve, reject) ->
    robot.http(url)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        if err
          logger.error e
          reject err
        try
          resolve(JSON.parse(body))
        catch e
          logger.error e
          reject e

module.exports =
  getHttpJson: getHttpJson
