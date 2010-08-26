class ApplicationController < ActionController::Base
  protect_from_forgery

  # Authentication
  before_filter :authenticate_user!
end
