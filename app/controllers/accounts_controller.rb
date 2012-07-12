class AccountsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user
  before_filter :correct_account, only: :show

  def index
    @txn      = @user.txns.build()
    @accounts = @user.accounts.paginate(page: params[:page])
  end

  def show
    @txn  = @user.txns.build(account_id: @account.id)
    @txns = @account.txns.paginate(page: params[:page])
  end

  def create
    other_party = User.find_by_id(params[:account][:other_party_id])
    account     = @user.open_account_with!(other_party)
    redirect_to user_account_path(@user, account)
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
