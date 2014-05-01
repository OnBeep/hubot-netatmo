# Description:
#   gets tweet from user
#
# Dependencies:
#   "netatmo": "1.0.0"
#
# Configuration:
#   HUBOT_NETATMO_CLIENT_ID
#   HUBOT_NETATMO_CLIENT_SECRET
#   HUBOT_NETATMO_USERNAME
#   HUBOT_NETATMO_PASSWORD
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
  client_id: process.env.HUBOT_NETATMO_CLIENT_ID
  client_secret: process.env.HUBOT_NETATMO_CLIENT_SECRET
  username: process.env.HUBOT_NETATMO_USERNAME
  password: process.env.HUBOT_NETATMO_PASSWORD

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
    unless config.client_id
      msg.send "Please set the HUBOT_NETATMO_CLIENT_ID environment variable."
      return
    unless config.client_secret
      msg.send "Please set the HUBOT_NETATMO_CLIENT_SECRET environment variable."
      return
    unless config.username
      msg.send "Please set the HUBOT_NETATMO_USERNAME environment variable."
      return
    unless config.password
      msg.send "Please set the HUBOT_NETATMO_PASSWORD environment variable."
      return
    unless options.device_id
      msg.send "Please set the HUBOT_NETATMO_DEVICE_ID environment variable."
      return

    unless netatmo_api
      netatmo_api = new Netatmo config


    netatmo_api.getMeasure options, (err, measure) ->
      return msg.send "Temperature #{measure[0]['value'][0][0]} CO2 #{measure[0]['value'][0][1]} Humidity #{measure[0]['value'][0][2]} Pressure #{measure[0]['value'][0][3]} Noise #{measure[0]['value'][0][4]}"
