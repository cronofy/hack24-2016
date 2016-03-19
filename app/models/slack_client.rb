require "addressable/uri"

class SlackClient
  include Hatchet

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def users
    result = do_get("users.list", {})
    result['members'].map { |u| OpenStruct.new(u) }
  end

  def channels
    result = do_get("channels.list", { exclude_archived: 1 })
    result['channels'].map{ |c| OpenStruct.new(id: c['id'], name: c['name']) }
  end

  def channel_info(channel_id)
    result = do_get("channels.info", { channel: channel_id })
    OpenStruct.new(result['channel'])
  end

  def channel_history(channel_id, oldest=1)
    result = do_get("channels.history", { channel: channel_id, oldest: oldest })
    OpenStruct.new(result)
  end

  def channel_history_each(channel_id, &block)
    oldest = 1
    begin
      page = channel_history(channel_id, oldest)
      page.messages.reverse.each do |message|
        yield OpenStruct.new(message)
        oldest = message['ts']
      end
    end while page.has_more
  end

  def do_get(method, params)
    log.debug { "#do_get #{method} #{params}" }
    params[:token] = user.slack_access_token
    response = connection.get(request_path(method, params))
    preprocess_response(response, method)
  end

  def preprocess_response(response, method)
    payload = JSON.parse(response.body)

    unless payload['ok']
      log.error { "##{method} #{payload['error']} #{payload}" }
      raise StandardError.new("##{method} failed with #{payload['error']} #{payload}")
    end

    payload
  end

  def request_path(method, params={})
    uri = Addressable::URI.new
    uri.query_values = params
    "/api/#{method}?#{uri.query}"
  end

  def connection
    @_connecton || Faraday.new(:url => 'https://slack.com')
  end

end