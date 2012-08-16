# Description:
#   A simple interaction with the built in HTTP Daemon
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   /
#   /hubot/version
#   /hubot/ping
#   /hubot/time
#   /hubot/info
#   /hubot/ip

spawn = require('child_process').spawn

module.exports = (robot) ->
  router = robot.router

  router.get "/", (req, res) ->
    stack = robot.connect.stack
    router = stack[stack.length - 1].handle

    res.write("<html>")
    res.write("<head>")
    res.write("<title>Hubot Web Server</title>")
    res.write("</head>")
    res.write("<body>")

    for route in router.lookup('*', 'GET')
      res.write("<p>GET <a href='#{route.path}'>#{route.path}</a></p>")

    res.write("</body>")

    res.end()

  router.get "/hubot/version", (req, res) ->
    res.end robot.version

  router.post "/hubot/ping", (req, res) ->
    res.end "PONG"

  router.get "/hubot/time", (req, res) ->
    res.end "Server time is: #{new Date()}"

  router.get "/hubot/info", (req, res) ->
    child = spawn('/bin/sh', ['-c', "echo I\\'m $LOGNAME@$(hostname):$(pwd) \\($(git rev-parse HEAD)\\)"])

    child.stdout.on 'data', (data) ->
      res.end "#{data.toString().trim()} running node #{process.version} [pid: #{process.pid}]"
      child.stdin.end()

  router.get "/hubot/ip", (req, res) ->
    robot.http('http://checkip.dyndns.org').get() (err, r, body) ->
      res.end body
