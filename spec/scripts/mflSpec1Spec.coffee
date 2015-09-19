describe 'fantasyscores', ->
  sc = require '../../scripts/mfl'
  fixture1 = require '../support/fixture1'
  mocks = require '../support/mocks'


  httpLeagueCall = null
  httpScoresCall = null
  robot = null
  msg = null

  beforeEach ->
    httpLeagueCall = new mocks.Http(JSON.stringify(fixture1.leagueData))
    httpScoresCall = new mocks.Http(JSON.stringify(fixture1.liveScoringData))
    msg = new mocks.Msg()
    robot = new mocks.Robot()
    sc(robot)

  it "should register a call back", ->
    # expect(robot.respond.calls.count()).toEqual 1
    expect(robot.responderFor("fantasyscores")).not.toBeUndefined()


  it "should contain all test names", (done) ->
    # given
    spyOn(robot, "http").and.callFake (url) ->
      if url.indexOf("liveScoring") > -1 then httpScoresCall else httpLeagueCall

    spyOn(msg, "send").and.callFake (value) ->
      expect(value).toContain("team 1")
      expect(value).toContain("team 2")
      expect(value).toContain("Score: 0")
      expect(value).toContain("Score: 14")
      expect(value).toContain(" Currently Playing")
      expect(value).toContain(" Game Seconds Remaining")
      done()

    # when
    robot.send "fantasyscores", msg
