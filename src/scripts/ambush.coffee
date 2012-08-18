# Description:
#   Send messages to users the next time they speak
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ambush <user name>: <message>
#
# Author:
#   jmoses

appendAmbush = (data, toUser, fromUser, message) ->
  if data[toUser.name]
    data[toUser.name].push message
  else
    data[toUser.name] = [[fromUser.name, message]]

refreshAmbushes = (robot) ->
  robot.brain.data.ambushes ||= {}

module.exports = (robot) ->
  refreshAmbushes(robot)

  robot.brain.on 'loaded', ->
    refreshAmbushes(robot)

  robot.respond /ambush (.*): (.*)/i, (msg) ->
    users = robot.usersForFuzzyName(msg.match[1])
    if users.length is 1
      user = users[0]
      appendAmbush(robot.brain.data.ambushes, user, msg.message.user, msg.match[2])
      msg.send "Ambush prepared"
    else if users.length > 1
      msg.send "Too many users like that"
    else
      msg.send "#{msg.match[1]}? Never heard of 'em"
  
  robot.hear /./i, (msg) ->
    ambushes = robot.brain.data.ambushes
    return if ambushes == undefined
    
    senderName = msg.message.user.name
    ambushesForSender = ambushes[senderName]
    return unless ambushesForSender?
    
    msg.send "Hey, #{senderName} while you were out:"
    for ambush in ambushesForSender
      msg.send "#{ambush[0]} says: #{ambush[1]}"
    msg.send "That's it. You were greatly missed."
    
    delete ambushes[senderName]
