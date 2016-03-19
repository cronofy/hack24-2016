require "addressable/uri"

class SlackClient
  include Hatchet

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def channels
    data = do_get("channels.list", { exclude_archived: 1 }, 'channels')
    data.map{ |c| OpenStruct.new(id: c['id'], name: c['name']) }
  end

  def channel_info(channel_id)
    data = do_get("channels.info", { channel: channel_id }, 'channel')
    OpenStruct.new(data)
  end

  def do_get(method, params, data)
    params[:token] = user.slack_access_token
    response = connection.get(request_path(method, params))
    preprocess_response(response, method)[data]
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