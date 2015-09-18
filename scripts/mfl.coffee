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
#   hubot: fantasyscores - print out the fantasy scores from myfantasyleague.com
#
#
# Authors:
#  Clayton Dukes cdffl@remailed.ws
#  Trever Shick trever@shick.io
#
_ = require 'lodash'
Promise = require 'promise'
{renderLiveScoringResults} = require './formatters'

leagueId = process.env.HUBOT_MFL_LEAGUE_ID
unless leagueId
  exit "You must enter your HUBOT_MFL_LEAGUE_ID in your environment variables"
leagueURL =  process.env.HUBOT_MFL_LEAGUE_URL
unless leagueURL
  exit "You must enter your HUBOT_MFL_LEAGUE_URL in your environment variables"

week = process.env.HUBOT_MFL_LEAGUE_WEEK or 1
LIVE_SCORING_URL = "#{leagueURL}/export?TYPE=liveScoring&L=#{leagueId}&W=#{week}&JSON=1"
OWNER_INFORMATION = "#{leagueURL}/export?TYPE=league&L=#{leagueId}&W=&JSON=1"

jsonGet = (robot, url) ->
  new Promise (resolve, reject) ->
    robot.http(url)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        if err
          robot.logger.error e
          reject err
        try
          resolve(JSON.parse(body))
        catch e
          robot.logger.error e
          reject e

teamName = (leagueData, team) ->
  x.name for x in leagueData.league.franchises.franchise when x.id is team.id

sendLiveScoringResults = (msg, leagueData, liveScoringData) ->
  teams = _(liveScoringData.liveScoring.matchup)
    .map (game) -> game.franchise
    .flatten()
    .map (team) ->
      team.name = teamName(leagueData, team)
      team.gameSecondsRemaining = parseInt(team.gameSecondsRemaining, 10)
      team.playersCurrentlyPlaying = parseInt(team.playersCurrentlyPlaying, 10)
      team
    .value()

  msg.send renderLiveScoringResults({"teams": teams})


onFantasyScores = (robot, msg) ->
  robot.logger.debug "Pulling liveScoringData from #{LIVE_SCORING_URL}"
  robot.logger.debug "Pulling leagueData from #{OWNER_INFORMATION}"
  jsonGet(robot, OWNER_INFORMATION)
    .then (leagueData) ->
      leagueData_str = JSON.stringify leagueData
      robot.logger.debug "onFantasyScores.jsonGet.OWNER_INFORMATION returns: #{leagueData_str}"
      return { leagueData: leagueData }
    .then (data) ->
      jsonGet(robot, LIVE_SCORING_URL).then (liveScoringData) ->
        liveScoringData_str = JSON.stringify liveScoringData
        robot.logger.debug "onFantasyScores.jsonGet.LIVE_SCORING_URL returns: #{liveScoringData_str}"
        data.liveScoringData = liveScoringData
        data
    .then (data) ->
      sendLiveScoringResults msg, data.leagueData, data.liveScoringData
    .then null,
      (err) -> msg.send "An error occurred in function onFantasyScores: #{err}"


module.exports = (robot) ->
  robot.logger.debug
  "myfantasyleague.com League Id:          #{leagueId} (HUBOT_MFL_LEAGUE_ID)"
  robot.logger.debug
  "myfantasyleague.com Week:               #{week} (HUBOT_MFL_LEAGUE_WEEK)"
  robot.logger.debug
  "myfantasyleague.com League Data from :  #{LIVE_SCORING_URL}"
  robot.logger.debug
  "myfantasyleague.com Team Data from :    #{OWNER_INFORMATION}"


  robot.respond /fantasyscores/i, (msg) -> onFantasyScores(robot, msg)
