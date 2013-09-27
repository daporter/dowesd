# encoding: utf-8

#
# Handles reconciling and unreconciling transactions.
#
class ReconciliationsController < ApplicationController
  before_filter :signed_in_user

  respond_to :html, :js

  def create
    @txn = Txn.find_for_account_holder(params[:txn_id], current_user)
    @reconciliation = @txn.create_reconciliation_for(current_user)

    respond_with(@txn) do |format|
      format.html { redirect_to [current_user, @txn.account] }
      format.js
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def destroy
  end
end
