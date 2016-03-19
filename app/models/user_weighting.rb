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
    channel_count(name) / total_count.to_f
  end

  def channel_count(name)
    match = @data.find { |message| message['channel'] == name }
    if match
      match['count']
    else
      0
    end
  end

  def to_hash
    channels_counts = @channels.map do |chan|
      [chan, get_channel_weight(chan)]
    end

    {
      name: @name,
      channels: channels_counts.to_h
    }
  end
end
