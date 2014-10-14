# Description:
#   How many people have rsvped for your next event?

EB = require('eventbrite')

checkEventbrite = (cb) ->
  client = EB
    app_key: process.env.EVENTBRITE_APP_KEY
    user_key: process.env.EVENTBRITE_USER_KEY

  client.user_list_events {'event_statuses': ['live']} , (err, data) ->
    unless data.events[0]
      return cb(null, {'tickets':[], 'title': '(No upcoming events)', 'start_date': ''})
    event = data.events[0].event
    return cb(null, event)

module.exports = (robot) ->
  robot.respond /eventbrite/, (msg) ->
    unless process.env.EVENTBRITE_APP_KEY && process.env.EVENTBRITE_USER_KEY
      return msg.send "You need to set up your Eventbrite API keys for this to work"
    else
      checkEventbrite (err, event) ->
        lines = [["#{ticketType.ticket.name}: #{ticketType.ticket.quantity_sold}"] for ticketType in event.tickets]
        msg.send "#{event.title} (#{event.start_date.split(' ')[0]})"
        [msg.send(line) for line in lines]
