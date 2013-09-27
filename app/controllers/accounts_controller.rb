class AccountsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_account, only: :show

  def index
    @txn      = current_user.txns.build(date: Date.today)
    @accounts = current_user.accounts.paginate(page: params[:account_page])
    @reverse_accounts =
      current_user.reverse_accounts.paginate(page: params[:reverse_account_page])
  end

  def show
    @txn  = current_user.txns.build(account_id: @account.id, date: Date.today)
    @txns = @account.txns.paginate(page: params[:page])
  end

  def create
    other_party = User.find_by_id(params[:account][:other_party_id])
    account     = current_user.open_account_with!(other_party)
    redirect_to user_account_path(current_user, account)
  end

  private

  def correct_account
    @account = (current_user.accounts.find_by_id(params[:id]) ||
                current_user.reverse_accounts.find_by_id(params[:id]))

    redirect_to root_path  if @account.nil?
  end
end
