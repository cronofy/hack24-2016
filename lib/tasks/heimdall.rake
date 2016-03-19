include Hatchet

namespace :heimdall do

  task :load_slack => :environment do
    user = User.first
    slack = SlackClient.new(user)

    slack_users = slack.users

    log.info { "heimdall:load_slack started" }

    slack.channels.each do |channel|
      log.info { "heimdall:load_slack loading channel=#{channel.id} #{channel.name}" }
      count = 0
      slack.channel_history_each(channel.id) do |message|
        # influx magic here
        count += 1
      end

      log.info { "heimdall:load_slack loaded #{count} messages from channel=#{channel.id}" }
    end

    log.info { "heimdall:load_slack completed" }

  end

  task :load_calendars => :environment do

    log.info { "heimdall:load_calendars started" }

    cronofy = CronofyClient.new

    count = 0

    cronofy.events.each do |event|
      #influx magic here
    end

    log.info { "heimdall:load_slack completed #{count} events" }
  end

end