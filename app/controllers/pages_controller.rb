class PagesController < ApplicationController
  allow_unauthenticated_access only: [:about,:authentification]
  before_action :resume_session, only: [:authentification]
  def about
    puts current_user.inspect
  end

  def authentification
  end

  def account
    puts current_user.inspect
  end
end
