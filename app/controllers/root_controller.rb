class RootController < ApplicationController

  helper_method :slack_channels

  def index

  end

  def destroy
    current_user.destroy if current_user
    redirect_to :root
  end

  def slack_channels
    @slack_channels ||= slack_client.channels
  end

end