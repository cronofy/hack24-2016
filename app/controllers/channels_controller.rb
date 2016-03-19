class ChannelsController < ApplicationController

  helper_method :channel, :channel_messages

  def show

  end

  def channel_id
    params[:id]
  end

  def channel
    slack_client.channel_info(channel_id)
  end

  def channel_messages
    slack_client.channel_history(channel_id).messages
  end
end