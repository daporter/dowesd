require "spec_helper"

describe "Account pages" do
  let(:user)       { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  before { @account = user.open_account_with!(other_user, 12300) }

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
                                     description: 'Foo') }
    let!(:txn2) { FactoryGirl.create(:txn,
                                     user:        other_user,
                                     account:     @account,
                                     description: 'Bar') }

    before do
      sign_in user
      visit user_account_path(user, @account)
    end

    it { should have_selector("title", text: other_user.name) }
    it { should have_selector("h3",    text: other_user.name) }

    describe "transactions" do
      it { should have_content(@account.balance_dollars) }
      it { should have_content(txn1.description) }
      it { should have_content(txn2.description) }
      it { should have_content(user.txns.count) }
    end
  end
end
