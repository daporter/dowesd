require "spec_helper"

describe "Txn pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    @account = FactoryGirl.create :account, user: user
    sign_in user
  end

  describe "txn creation" do
    before { visit user_account_path(user, @account) }

    describe "with invalid information" do
      it "shoud not create a txn" do
        expect { click_button "Add" }.should_not change(Txn, :count)
      end

      describe "error messages" do
        before { click_button "Add" }
        it { should have_content("error") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "txn_date",           with: Date.today
        fill_in "txn_description",    with: "Lorem ipsum"
        fill_in "txn_amount_dollars", with: "12"
      end

      it "should create a txn" do
        expect { click_button "Add" }.should change(Txn, :count).by(1)
      end
    end
  end

  describe "txn destruction" do
    before { @txn = FactoryGirl.create(:txn, user: user, account: @account) }

    describe "as correct user" do
      before { visit user_account_path(user, @account) }

      it "should delete a txn" do
        link_id = "delete-txn-#{@txn.id}"
        expect { click_link link_id  }.should change(Txn, :count).by(-1)
      end
    end
  end
end
