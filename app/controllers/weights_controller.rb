class WeightsController < ApplicationController
  include InfluxConnection

  def index
    @data = get_results
    render json: @data
  end

  private

  def get_results
    channels = list_channels
    user_weights = get_username_weights
    usernames = user_weights.map { |data| data['username'] }.uniq
    people_weights = []

    usernames.each do |user|
      filtered_data = user_weights.select {|data| data['username'] == user}
      mapping = UserWeighting.new(user, filtered_data, channels)
      people_weights << mapping.to_hash
    end

    {
      channels: list_channels,
      people: people_weights
    }
  end

  def list_channels
    raw = influx.query('select count(message) from messages group by channel')
    raw.map { |data| data['tags']['channel'] }.reject { |chan| chan == "general" }
  end

  def get_username_weights
    influx.query('select count(message) into counts from messages group by username')
    influx.query('select count(message) into counts from messages group by channel, username');

    influx.query('select * from counts').first['values']
  end
end
