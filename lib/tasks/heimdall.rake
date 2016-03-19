include Hatchet

namespace :heimdall do

  task :clean_db => :environment do
    ImportSlack.new.nuke_db!
  end

  task :load_slack => :environment do
    user = User.first
    slack = SlackClient.new(user)
    import = ImportSlack.new

    slack_users = slack.users
    user_map = Hash[slack_users.map { |u| [u.id, u.profile['email']] }]

    log.info { "heimdall:load_slack started" }

    slack.channels.each do |channel|
      log.info { "heimdall:load_slack loading channel=#{channel.id} #{channel.name}" }
      count = 0
      slack.channel_history_each(channel.id) do |message|
        # influx magic here
        mapped_user = user_map[message.user]

        next if mapped_user.blank?

        count += 1
        data = {
          email: mapped_user,
          text: message.text.gsub(/[^0-9a-z: ]/i, ''),
          channel: channel.name,
          timestamp: message.ts.to_i
        }
        import.import([data])

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
