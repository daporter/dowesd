# encoding: utf-8

#
# Handles user logins and logouts.
#
class SessionsController < ApplicationController
  def new
  end

  def create
    session = params[:session]
    user = User.find_by_email(session[:email])
    if user && user.authenticate(session[:password])
      sign_in user
      redirect_back_or user_accounts_path(user)
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
