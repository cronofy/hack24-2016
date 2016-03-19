class ChannelsController < ApplicationController

  helper_method :channel

  def show

  end

  def channel_id
    params[:id]
  end

  def channel
    slack_client.channel_info(channel_id)
  end
end