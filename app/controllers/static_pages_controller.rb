# encoding: utf-8

#
# Handles the applications' static pages.
#
class StaticPagesController < ApplicationController
  def home
    redirect_to user_accounts_path(current_user) if signed_in?
  end

  def about
  end

  def contact
  end
end
