include Hatchet

namespace :heimdall do

  desc "Cleans DB"
  task :clean_db => :environment do
    ImportSlack.new.nuke_db!
  end

  desc "Loads data from Slack"
  task :load_slack => :environment do
    slack = SlackClient.new(User.first)
    import = ImportSlack.new

    user_map = Hash[slack.users.map { |u| [u.id, u.profile['email']] }]

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
    cronofy = CronofyClient.new
    import = ImportCalendar.new

    log.info { "heimdall:load_calendars started" }

    count = 0

    cronofy.events.each do |event|
      import.import_event(event)
    end

    log.info { "heimdall:load_slack completed #{count} events" }
  end

end
