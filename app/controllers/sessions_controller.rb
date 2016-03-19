class SessionsController < ApplicationController

  def create
    log.debug { "#create #{auth_hash.inspect}" }

    case auth_hash['provider']
    when 'slack'
      process_slack_login(auth_hash)
      flash.now[:success] = "Connected to Slack"
    else
      log.warn { "#create provider=#{auth_hash['provider']} not recognised" }
      flash.now[:error] = "Unrecognised provider login"
    end
    redirect_to :root
  end

  def failure
    case params[:strategy]
    when "slack"
      flash.now[:alert] = "Unable to connect to your Slack account: #{params[:message]}"
    else
      flash.now[:error] = "Failure from unrecognised provider"
    end
    redirect_to :root
  end

  def destroy
    logout
    flash.now[:info] = "Logged out"
    redirect_to :root
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def process_slack_login(auth_hash)
    log.debug { "auth_hash=#{auth_hash.inspect}" }

    user = User.find_or_create_by(slack_user_id: auth_hash['uid'])

    user.slack_access_token = auth_hash['credentials']['token']
    user.slack_team_id = auth_hash['info']['team_id']
    user.save

    login(user)
  end

end
