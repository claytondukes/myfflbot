# Description:
#   Prints out current league scores from myfantasyleague.com to a Slack channel
#
# Dependencies:
#   'promise'
#
# Configuration:
#   HUBOT_MFL_LEAGUE_ID - set the league ID
#   HUBOT_MFL_LEAGUE_WEEK - the week, ordinal number
#
# Commands:
#   hubot fantasyscores - print out the fantasy scores from myfantasyleague.com
#
#
# Authors:
#  Clayton Dukes cdffl@remailed.ws
#  Trever Shick trever@shick.io
#
_       = require 'lodash'
Log     = require 'log'
Config  = require './util/mfl-config'
Q       = require 'q'

{ renderLiveScoringResults } = require './util/mfl-formatters'
{ getHttpJson } = require './util/http-promise'
config  = new Config()
logger  = new Log(process.env.HUBOT_LOG_LEVEL or 'info')



teamName = (leagueData, team) ->
  x.name for x in leagueData.league.franchises.franchise when x.id is team.id

sendLiveScoringResults = (msg, leagueData, liveScoringData) ->
  teams = _(liveScoringData.liveScoring.matchup)
    .map (game) ->
      game.franchise
    .flatten()
    .map (team) ->
      team.name = teamName(leagueData, team)
      team.gameSecondsRemaining = parseInt(team.gameSecondsRemaining, 10)
      team.playersCurrentlyPlaying = parseInt(team.playersCurrentlyPlaying, 10)
      team
    .value()

  msg.send renderLiveScoringResults({"teams": teams})


onFantasyScores = (robot, msg) ->
  logger.debug "Pulling liveScoringData from #{config.liveScoringUrl}"
  logger.debug "Pulling leagueData from #{config.ownerInformationUrl}"
  Q.all([ getHttpJson(robot, config.ownerInformationUrl),
          getHttpJson(robot, config.liveScoringUrl) ])
  .then (d) ->
    sendLiveScoringResults msg, d[0], d[1]
  .then null,
    (err) -> msg.send "An error occurred in function onFantasyScores: #{err}"


module.exports = (robot) ->
  config.debug()

  robot.respond /fantasyscores/i, (msg) -> onFantasyScores(robot, msg)
