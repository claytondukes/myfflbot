Handlebars = require 'handlebars'

LIVE_SCORING_RESULTS_TEMPLATE = Handlebars.compile("""
  `Live Scoring Results`\n
  ```
  {{#each teams}}
  {{name}}    Score: {{score}}
    {{#if gameSecondsRemaining}}
      Currently Playing: {{playersCurrentlyPlaying}}
      Game Seconds Remaining: {{gameSecondsRemaining}}
    {{/if}}
  {{/each}}
  ```
""")


module.exports =
  renderLiveScoringResults : (ctx) -> LIVE_SCORING_RESULTS_TEMPLATE(ctx)
