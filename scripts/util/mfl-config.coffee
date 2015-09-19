Log = require 'log'

class Config
  constructor: (opts) ->
    @logger = new Log(process.env.HUBOT_LOG_LEVEL or 'info')
    @leagueId = parseInt(process.env.HUBOT_MFL_LEAGUE_ID, 10)
    @leagueUrl =  process.env.HUBOT_MFL_LEAGUE_URL
    @week = parseInt(opts?.week or process.env.HUBOT_MFL_LEAGUE_WEEK or 1, 10)
    @liveScoringUrl = "#{@leagueUrl}/export?TYPE=liveScoring&L=#{@leagueId}&W=#{@week}&JSON=1"
    @ownerInformationUrl = "#{@leagueUrl}/export?TYPE=league&L=#{@leagueId}&W=&JSON=1"

    unless @leagueId
      @logger.error "You must enter your HUBOT_MFL_LEAGUE_ID in your environment variables"
      process.exit 1

    unless @leagueUrl
      @logger.error "You must enter your HUBOT_MFL_LEAGUE_URL in your environment variables"
      process.exit 1

  withWeek: (week) ->
    new Config({ week: week })

  debug: ->
    @logger.debug "myfantasyleague.com League Id:          #{@leagueId} (HUBOT_MFL_LEAGUE_ID)"
    @logger.debug "myfantasyleague.com Week:               #{@week} (HUBOT_MFL_LEAGUE_WEEK)"
    @logger.debug "myfantasyleague.com League Data from :  #{@liveScoringUrl}"
    @logger.debug "myfantasyleague.com Team Data from :    #{@ownerInformationUrl}"

module.exports = Config
