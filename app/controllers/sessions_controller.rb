class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  allow_unauthenticated_access only: %i[ destroy ] # edgecase to deal with email confirmations
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def session_params
    params.permit(:email_address, :password)
  end

  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user&.authenticate(params[:password])
      start_new_session_for(user)
      redirect_to root_path, notice: "Signed in successfully."
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
