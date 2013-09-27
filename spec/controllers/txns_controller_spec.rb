require 'spec_helper'

describe TxnsController do
  let(:user) { FactoryGirl.create(:user) }

  describe 'GET edit' do
    it 'assigns the txn' do
      controller.stub(:current_user).and_return(user)
      txn = FactoryGirl.create(:txn, user: user)
      get :edit, id: 1
      assigns(:txn).should eq(txn)
    end
  end

  describe 'POST create' do
    it 'redirects to the signin page when is not signed in' do
      post :create
      response.should redirect_to(signin_path)
    end
  end

  describe 'PUT update' do
    before { controller.stub(:current_user).and_return(user) }

    it 'updates the txn from the params' do
      txn = FactoryGirl.create(:txn, user: user)
      put :update, id: txn.id, txn: { description: 'new-description' }
      txn.reload.description.should == 'new-description'
    end

    it 'redirects to the account page' do
      txn = FactoryGirl.create(:txn, user: user)
      put :update, id: txn.id
      response.should redirect_to(user_account_path(user, txn.account))
    end
  end

  describe 'DELETE destroy' do
    it 'redirects to the signin page when user is not signed in' do
      delete :destroy, id: 1
      response.should redirect_to(signin_path)
    end
  end

  describe 'GET descriptions' do
    let(:txns) { [double(description: 'foo'),
                  double(description: 'bar'),
                  double(description: 'bar')] }

    before do
      controller.stub(:current_user).and_return(user)
      Txn.stub(:by_user_and_matching_description) { txns }
      get :descriptions, query: 'foo', format: 'json'
    end

    it 'responds with JSON' do
      response.header['Content-Type'].should include 'application/json'
    end

    it 'returns a list of unique descriptions' do
      response.body.should == ['foo', 'bar'].to_json
    end
  end
end
