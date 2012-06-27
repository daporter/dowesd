require 'spec_helper'

describe TxnsController do
  describe "GET descriptions" do
    before do
      txns = [stub_model(Txn, description: "foo"),
              stub_model(Txn, description: "bar"),
              stub_model(Txn, description: "bar")]
      Txn.stub(:by_user_and_matching_description) { txns }

      sign_in FactoryGirl.create(:user)
      get :descriptions, query: "foo", format: "json"
    end

    it "responds with JSON" do
      response.header["Content-Type"].should include "application/json"
    end

    it "returns a list of unique descriptions" do
      response.body.should == ["foo", "bar"].to_json
    end
  end
end
