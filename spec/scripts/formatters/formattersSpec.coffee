{ renderLiveScoringResults } = require '../../../scripts/formatters'

describe 'formatters', ->

  describe 'renderLiveScoringResults', ->

    it 'renders all teams', ->
      teams = [
        { name: 'name 1', score: 15, gameSecondsRemaining: 1, playersCurrentlyPlaying: 3},
        { name: 'name 2', score: 17, gameSecondsRemaining: 2, playersCurrentlyPlaying: 4}
      ]
      output = renderLiveScoringResults({teams: teams})

      expect(output).toContain "`Live Scoring Results`"
      expect(output).toContain "name 1    Score: 15"
      expect(output).toContain "Currently Playing: 3"
      expect(output).toContain "Game Seconds Remaining: 1"
      expect(output).toContain "name 2    Score: 17"
      expect(output).toContain "Currently Playing: 4"
      expect(output).toContain "Game Seconds Remaining: 2"

    it 'skips details for finished games', ->
      teams = [
        { name: 'name 1', score: 15, gameSecondsRemaining: 0, playersCurrentlyPlaying: 3},
        { name: 'name 2', score: 17, gameSecondsRemaining: 0, playersCurrentlyPlaying: 4}
      ]
      output = renderLiveScoringResults({teams: teams})
      expect(output).toContain "`Live Scoring Results`"
      expect(output).toContain "name 1    Score: 15"
      expect(output).toContain "name 2    Score: 17"

      expect(output).not.toContain "Currently Playing: 3"
      expect(output).not.toContain "Game Seconds Remaining: 0"
      expect(output).not.toContain "Currently Playing: 4"
      expect(output).not.toContain "Game Seconds Remaining: 0"
