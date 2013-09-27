# encoding: utf-8

#
# The top-level controller.
#
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
end
