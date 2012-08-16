User = require '../src/user'
Assert = require 'assert'

user = new User "Fake User", {name: 'fake', type: "groupchat"}
Assert.equal "Fake User", user.id
Assert.equal "groupchat", user.type
Assert.equal "fake", user.name

user = new User "Fake User", {room: "chat@room.jabber", type: "groupchat"}
Assert.equal "Fake User", user.id
Assert.equal "chat@room.jabber", user.room
Assert.equal "groupchat", user.type
Assert.equal "Fake User", user.name # Make sure that if no name is given, we fallback to the ID
