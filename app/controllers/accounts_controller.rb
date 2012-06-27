class AccountsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user
  before_filter :correct_account, except: :index

  def index
    @txn      = @user.txns.build(date: Date.today)
    @accounts = @user.accounts.paginate(page: params[:page])
  end

  def show
    @txn  = @user.txns.build(account_id: @account.id, date: Date.today)
    @txns = @account.txns.paginate(page: params[:page])
  end

  private

  def correct_user
    @user = User.find_by_id(params[:user_id])
    if current_user != @user
      redirect_to root_path
    end
  end

  def correct_account
    @account = (@user.accounts.find_by_id(params[:id]) ||
                @user.reverse_accounts.find_by_id(params[:id]))
    if @account.nil?
      redirect_to root_path
    end
  end
end
