require 'spec_helper'

describe ReconciliationsController do
  describe '#create' do
    before do
      @user    = FactoryGirl.create(:user)
      @account = FactoryGirl.create(:account, user: @user)
      @txn     = FactoryGirl.create(:txn, account: @account, user: @user)
    end

    context 'when the user is signed in' do
      before do
        controller.stub(:current_user).and_return(@user)
        @txn.stub(:create_reconciliation_for)
      end

      it 'tries to find the specified txn' do
        Txn.should_receive(:find_for_account_holder).with('1', @user) { @txn }
        post :create, txn_id: 1
      end

      context "when the user is a holder of the txn's account" do
        before do
          Txn.stub(:find_for_account_holder).and_return(@txn)
        end

        it 'creates a txn reconciliation for the user' do
          @txn.should_receive(:create_reconciliation_for).with(@user)
          post :create, txn_id: 1
        end

        it 'redirects to the account page' do
          post :create, txn_id: 1
          response.should redirect_to(user_account_path(@user, @account))
        end
      end

      context "when the user is not a holder of the txn's account" do
        it 'redirects to the root page' do
          Txn.stub(:find_for_account_holder).
            and_raise(ActiveRecord::RecordNotFound)
          post :create, txn_id: 1
          response.should redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the signin page' do
        post :create, txn_id: 1
        response.should redirect_to(signin_path)
      end
    end
  end
end
