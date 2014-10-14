# Description:
#   How many people have rsvped for your next event?

EB = require('eventbrite')

checkEventbrite = (cb) ->
  client = EB
    app_key: process.env.EVENTBRITE_APP_KEY
    user_key: process.env.EVENTBRITE_USER_KEY

  client.user_list_events {'event_statuses': ['live']} , (err, data) ->
    return cb(null, []) unless data.events[0]
    event = data.events[0].event
    return cb(null, event)

module.exports = (robot) ->
  robot.respond /eventbrite/, (msg) ->
    checkEventbrite (err, event) ->
      lines = [["#{ticketType.ticket.name}: #{ticketType.ticket.quantity_sold}"] for ticketType in event.tickets]
      msg.send "#{event.title} (#{event.start_date.split(' ')[0]})"
      [msg.send(line) for line in lines]
