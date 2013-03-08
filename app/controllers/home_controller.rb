require 'vline'

class HomeController < ApplicationController
  # require login
  before_filter :authenticate_user!

  def index
    @users = User.all
  end
end
