require 'spec_helper'

describe TxnsController do
  let(:user) { FactoryGirl.create(:user) }

  describe 'GET descriptions' do
    let(:txns) { [stub(description: 'foo'),
                  stub(description: 'bar'),
                  stub(description: 'bar')] }

    before do
      Txn.stub(:by_user_and_matching_description) { txns }
      sign_in user
      get :descriptions, query: 'foo', format: 'json'
    end

    it 'responds with JSON' do
      response.header['Content-Type'].should include 'application/json'
    end

    it 'returns a list of unique descriptions' do
      response.body.should == ['foo', 'bar'].to_json
    end
  end

  describe 'GET edit' do
    it 'assigns the txn' do
      sign_in user
      txn = FactoryGirl.create(:txn, user: user)
      get :edit, id: 1
      assigns(:txn).should eq(txn)
    end
  end

  describe 'PUT update' do
    before { sign_in user }

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
end
