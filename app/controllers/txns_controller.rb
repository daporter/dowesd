# encoding: utf-8

#
# Handles operations on account transactions.
#
class TxnsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: [:edit, :update, :destroy]

  respond_to :html, except: :descriptions
  respond_to :json, only: [:update, :descriptions]

  def create
    @txn     = current_user.txns.build(params[:txn])
    @account = @txn.account
    respond_with(@txn) do |format|
      if @txn.save
        flash[:success] = 'Transaction created'
        format.html { redirect_to [current_user, @account] }
      else
        @txns = @account.txns.paginate(page: params[:page])
        format.html { render 'accounts/show' }
      end
    end
  end

  def edit
    respond_with @txn
  end

  def update
    @txn.assign_attributes(params[:txn])
    @account = @txn.account
    respond_with(@txn) do |format|
      if @txn.save
        flash[:success] = 'Transaction updated'
        format.html { redirect_to [current_user, @account] }
      else
        @txns = @account.txns.paginate(page: params[:page])
        format.html { render 'accounts/show' }
      end
    end
  end

  def destroy
    @txn.destroy
    flash[:success] = 'Transaction deleted'
    redirect_to [current_user, @txn.account]
  end

  def descriptions
    txns = Txn.by_user_and_matching_description(current_user, params[:query])
    descriptions = txns.map(&:description).uniq

    render json: descriptions
  end

  private

  def correct_user
    @txn = current_user.txns.find(params[:id])
  rescue
    redirect_to root_path
  end
end
