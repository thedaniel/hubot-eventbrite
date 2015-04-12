# Description:
#   How many people have rsvped for your future events?

EB = require('eventbrite')

checkEventbrite = (cb) ->
  client = EB
    app_key: process.env.EVENTBRITE_APP_KEY
    user_key: process.env.EVENTBRITE_USER_KEY

  client.user_list_events {'event_statuses': ['live']} , (err, data) ->
    unless data.events[0]
      return cb(null, {'tickets':[], 'title': '(No upcoming events)', 'start_date': ''})
    events = (e.event for e in data.events)
    return cb(null, events)

module.exports = (robot) ->
  robot.respond /eventbrite/, (msg) ->
    unless process.env.EVENTBRITE_APP_KEY && process.env.EVENTBRITE_USER_KEY
      return msg.send "You need to set up your Eventbrite API keys for this to work"
    else
      checkEventbrite (err, events) ->
        for event in events
          lines = [["#{ticketType.ticket.name}: #{ticketType.ticket.quantity_sold}"] for ticketType in event.tickets]
          if process.env.HUBOT_SLACK_TOKEN? #lolslack
            msg.send "..{ #{event.title} }.. #{lines.join ' - '}"
          else
            msg.send "#{event.title} (#{event.start_date.split(' ')[0]})"
            [msg.send(line) for line in lines]
