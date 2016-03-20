class WeightsController < ApplicationController
  include InfluxConnection
  include Hatchet

  def index
    @data = get_results(params[:startDate], params[:endDate])
    render json: @data
  end

  def show
    @id = params[:id]
    @data = get_username_weights.select { |usr| usr['username'].start_with? @id }
  end

  private

  def get_results(startdate, enddate)
    channels = list_channels
    user_weights = {}
    if startdate && enddate
      user_weights = get_username_weights(DateTime.parse(startdate).rfc3339(9), DateTime.parse(enddate).rfc3339(9))
    else
      user_weights = get_username_weights()
    end
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

  def get_username_weights(start = nil, end_date = nil)
    log.info { "#get_username_weights start=#{start}, end_date=#{end_date}" }
    if start && end_date
      influx.query("drop series from datecounts")
      log.info { "select count(message) into datecounts from messages where time > '#{start}' and time < '#{end_date}' group by username" }
      influx.query("select count(message) into datecounts from messages where timestamp > '#{start}' and timestamp < '#{end_date}' group by username")
      influx.query("select count(message) into datecounts from messages where timestamp > '#{start}' and timestamp < '#{end_date}' group by channel, username");
      influx.query('select * from datecounts').first['values']
    else
      influx.query("drop series from counts")
      influx.query('select count(message) into counts from messages group by username')
      influx.query('select count(message) into counts from messages group by channel, username');
      influx.query('select * from counts').first['values']
    end
  end
end
