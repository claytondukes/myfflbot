Config = require '../../../scripts/mfl-config'

describe 'mfl-config', ->
  describe 'leagueId', ->
    beforeEach ->
      @oldValue = process.env.HUBOT_MFL_LEAGUE_ID
      delete process.env.HUBOT_MFL_LEAGUE_ID

    afterEach ->
      if @oldValue isnt undefined
        process.env.HUBOT_MFL_LEAGUE_ID = @oldValue

    it 'looks at HUBOT_MFL_LEAGUE_ID for its value', ->
      process.env.HUBOT_MFL_LEAGUE_ID = 763
      config = new Config()
      expect(config.leagueId).toEqual 763

    it 'exits if not set', ->
      spyOn(process, 'exit')
      config = new Config()
      expect(process.exit).toHaveBeenCalledWith 1

  describe 'ownerInformationUrl', ->
    it 'uses leagueUrl and leagueId', ->
      process.env.HUBOT_MFL_LEAGUE_URL = "http://somewhere.rainbow"
      process.env.HUBOT_MFL_LEAGUE_ID = 7777
      expected = "http://somewhere.rainbow/export?TYPE=league&L=7777&W=&JSON=1"
      expect(new Config().ownerInformationUrl).toBe expected

  describe 'liveScoringUrl', ->
    it 'uses leagueUrl and leagueId', ->
      process.env.HUBOT_MFL_LEAGUE_URL = "http://somewhere.rainbow"
      process.env.HUBOT_MFL_LEAGUE_ID = 7777
      expected = "http://somewhere.rainbow/export?TYPE=liveScoring&L=7777&W=97&JSON=1"
      expect(new Config().liveScoringUrl).toBe expected

    it 'changes by week', ->
      process.env.HUBOT_MFL_LEAGUE_WEEK = 3
      expected = "http://somewhere.rainbow/export?TYPE=liveScoring&L=7777&W=3&JSON=1"
      expect(new Config().liveScoringUrl).toBe expected

    it 'changes by week per config instance', ->
      process.env.HUBOT_MFL_LEAGUE_WEEK = 7
      expected = "http://somewhere.rainbow/export?TYPE=liveScoring&L=7777&W=5&JSON=1"
      expect(new Config().withWeek(5).liveScoringUrl).toBe expected

  describe 'leagueUrl', ->
    beforeEach ->
      @oldValue = process.env.HUBOT_MFL_LEAGUE_URL
      delete process.env.HUBOT_MFL_LEAGUE_URL

    afterEach ->
      if @oldValue isnt undefined
        process.env.HUBOT_MFL_LEAGUE_URL = @oldValue

    it 'looks at HUBOT_MFL_LEAGUE_URL for its value', ->
      process.env.HUBOT_MFL_LEAGUE_URL = 'http://jimmycrackcorn.com'
      config = new Config()
      expect(config.leagueUrl).toEqual 'http://jimmycrackcorn.com'

    it 'exits if not set', ->
      spyOn(process, 'exit')
      config = new Config()
      expect(process.exit).toHaveBeenCalledWith 1

  describe 'weeks', ->
    beforeEach ->
      @oldWeek = process.env.HUBOT_MFL_LEAGUE_WEEK
      delete process.env.HUBOT_MFL_LEAGUE_WEEK

    afterEach ->
      if @oldWeek isnt undefined
        process.env.HUBOT_MFL_LEAGUE_WEEK = @oldWeek

    it 'defaults to week 1', ->
      expect(new Config().week).toBe 1

    it 'can be overridden via a method', ->
      c = new Config()
      expect(c.week).toBe 1
      expect(c.withWeek(2).week).toBe 2

    it 'can be overridden via HUBOT_MFL_LEAGUE_WEEK', ->
      process.env.HUBOT_MFL_LEAGUE_WEEK = 5
      expect(new Config().week).toEqual 5
