class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
      redirect_back_or user  # redirect_to user
    else
      flash.now[:danger] = 'invalid email/password combination' # not quite right
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
