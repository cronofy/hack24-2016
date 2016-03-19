SLACK_CLIENT_ID = '3231855906.27984617825'
SLACK_CLIENT_SECRET = 'c6f84b3a599a95f8439938832bcc47d7'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack, SLACK_CLIENT_ID, SLACK_CLIENT_SECRET, {
    scope: "identify channels:read channels:history groups:read chat:write:bot commands"
  }
end

class OmniAuthLogger
  include Hatchet

  [:debug, :info, :warn, :error, :fatal].each do |level|
    define_method(level) do |message|
      log.add(level, message)
    end
  end
end

OmniAuth.config.logger = OmniAuthLogger.new
