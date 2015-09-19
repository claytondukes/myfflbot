require('coffee-script/register');

process.exit = function() {}

// shut up the tests
process.env.HUBOT_LOG_LEVEL = 'CRITICAL'
process.env.HUBOT_MFL_LEAGUE_URL = 9999
process.env.HUBOT_MFL_LEAGUE_WEEK = 97
process.env.HUBOT_MFL_LEAGUE_ID = 93939
