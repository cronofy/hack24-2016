class UserWeighting
  def initialize(name, data, channels)
    @name = name
    @data = data
    @channels = channels
  end

  def total_count
    @data.find { |message| message['channel'].nil? }['count']
  end

  def get_channel_weight(name)
    channel_count(name) / total_count
  end

  def channel_count(name)
    @data.find { |message| message['channel'] == name }['count']
  end

  def to_hash
    channels_counts = @channels.map do |chan|
      { chan => get_channel_weight(chan) }
    end

    {
      name: @name,
      channels: channels_counts
    }
  end
end
