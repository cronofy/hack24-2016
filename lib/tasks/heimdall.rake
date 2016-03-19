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

end