class RootController < ApplicationController

  def index

  end

  def destroy
    current_user.destroy if current_user
    redirect_to :root
  end
end