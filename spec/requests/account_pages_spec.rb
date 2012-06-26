require "spec_helper"

describe "Account pages" do
  let(:user)       { FactoryGirl.create(:user, name: "David") }
  let(:other_user) { FactoryGirl.create(:user, name: "Deciana") }
  before { @account = user.open_account_with!(other_user) }

  subject { page }

  describe "account index page" do
    before do
      sign_in user
      visit user_accounts_path(user)
    end

    it { should have_selector("title", text: full_title("Accounts")) }
    it { should have_selector("h3", text: "Accounts") }
    it do
      should have_link(other_user.name, href: user_account_path(user, @account))
    end
  end

  describe "account page" do
    let!(:txn1) { FactoryGirl.create(:txn,
                                     user:        user,
                                     account:     @account,
                                     description: "Foo",
                                     amount:      5000) }
    let!(:txn2) { FactoryGirl.create(:txn,
                                     user:        other_user,
                                     account:     @account,
                                     description: "Bar",
                                     amount:      8000) }

    describe "when current user is account user" do
      before do
        sign_in user
        visit user_account_path(user, @account)
      end

      it { should have_selector("title", text: other_user.name) }
      it { should have_selector("h1",    text: other_user.name) }

      describe "transactions" do
        it { should have_content(txn1.description) }
        it { should have_content(txn2.description) }
        it { should have_content(user.txns.count) }
      end

      describe "balance" do
        it { should have_content("David owes Deciana $30.00") }
      end
    end

    describe "when current user is account other party" do
      before do
        sign_in other_user
        visit user_account_path(other_user, @account)
      end

      it { should have_selector("title", text: "Account with #{user.name}") }
    end
  end
end
