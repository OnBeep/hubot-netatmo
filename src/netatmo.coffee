# Description:
#   gets tweet from user
#
# Dependencies:
#   "netatmo": "1.0.0"
#
# Configuration:
#   HUBOT_NETATMO_CONSUMER_KEY
#   HUBOT_NETATMO_CONSUMER_SECRET
#   HUBOT_NETATMO_ACCESS_TOKEN
#   HUBOT_NETATMO_ACCESS_TOKEN_SECRET
#
# Commands:
#   hubot netatmo <twitter username> - Show last tweet from <twitter username>
#   hubot netatmo <twitter username> <n> - Cycle through tweet with <n> starting w/ latest
#
# Author:
#   ampledata
#


Netatmo = require('netatmo')


config =
  client_id: process.env.HUBOT_NETATMO_CONSUMER_KEY
  client_secret: process.env.HUBOT_NETATMO_CONSUMER_SECRET
  username: process.env.HUBOT_NETATMO_ACCESS_TOKEN
  password: process.env.HUBOT_NETATMO_ACCESS_TOKEN_SECRET

options =
  device_id: process.env.HUBOT_NETATMO_DEVICE_ID # "70:ee:50:03:98:4c"
  scale: "30min"
  type: [
    "Temperature"
    "CO2"
    "Humidity"
    "Pressure"
    "Noise"
  ]


module.exports = (robot) ->
  netatmo_api = undefined

  robot.respond /(weather|noise)/i, (msg) ->
    unless config.consumer_key
      msg.send "Please set the HUBOT_NETATMO_CONSUMER_KEY environment variable."
      return
    unless config.consumer_secret
      msg.send "Please set the HUBOT_NETATMO_CONSUMER_SECRET environment variable."
      return
    unless config.access_token
      msg.send "Please set the HUBOT_NETATMO_ACCESS_TOKEN environment variable."
      return
    unless config.access_token_secret
      msg.send "Please set the HUBOT_NETATMO_ACCESS_TOKEN_SECRET environment variable."
      return
    unless options.device_id
      msg.send "Please set the HUBOT_NETATMO_DEVICE_ID environment variable."
      return

    unless netatmo_api
      netatmo_api = new Netatmo config


    netatmo_api.getMeasure options, (err, measure) ->
      return msg.send measure[0] if measure[0]