sc = require '../../../scripts/mfl'
mocks = require '../../support/mocks'
{ leagueData, liveScoringData } = require '../../support/fixture1'

describe 'mfl', ->

  describe 'fantasyscores', ->

    it "should register a call back", ->
      # expect(robot.respond.calls.count()).toEqual 1
      robot = new mocks.Robot()
      sc(robot)
      expect(robot.responderFor("fantasyscores")).not.toBeUndefined()


    it "should contain all test names", (done) ->
      msg = new mocks.Msg()
      robot = new mocks.Robot()
      robot.expectHttpAndRespond {body: JSON.stringify(leagueData)}
      robot.expectHttpAndRespond {body: JSON.stringify(liveScoringData)}
      sc(robot)

      # given
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

  describe 'error handing', ->

    it "should notify of an error when loading leagues", (done) ->
      msg = new mocks.Msg()

      robot = new mocks.Robot()
      robot.expectHttpAndRespond({err: new Error("xxx")})

      sc(robot) # initialize module

      spyOn(msg, "send").and.callFake (value) ->
        expect(value).toEqual "An error occurred in function onFantasyScores: Error: xxx"
        done()

      # when
      robot.send "fantasyscores", msg

    it "should notify of an error when loading scores", (done) ->
      msg = new mocks.Msg()

      robot = new mocks.Robot()
      robot.expectHttpAndRespond({ body : JSON.stringify(leagueData) })
      robot.expectHttpAndRespond({ err : new Error("yyy") })

      sc(robot) # initialize module

      spyOn(msg, "send").and.callFake (value) ->
        expect(value).toEqual "An error occurred in function onFantasyScores: Error: yyy"
        done()

      # when
      robot.send "fantasyscores", msg
