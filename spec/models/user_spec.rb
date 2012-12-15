# == Schema Information
# Schema version: 20120626235852
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(50)       not null
#  email           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)      not null
#  remember_token  :string(255)
#
# Indexes
#
#  index_users_on_email           (email) UNIQUE
#  index_users_on_remember_token  (remember_token)
#

require "spec_helper"

describe User do
  let(:user){ User.new }

  it { should have_many(:accounts) }
  it { should have_many(:other_parties).through(:accounts) }
  it { should have_many(:reverse_accounts) }
  it { should have_many(:reverse_other_parties).through(:reverse_accounts) }
  it { should have_many(:txns) }
  it { should have_many(:reconciliations).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(50) }

  it { should validate_presence_of(:email) }
  it { should validate_format_of(:email).with('user@example.com') }
  it { should_not validate_format_of(:email).with('user@example.') }

  it 'validates uniqueness of :email' do
    user1 = FactoryGirl.create(:user, email: 'user@example.com')
    user2 = FactoryGirl.build(:user, email: 'user@example.com')
    user2.should_not be_valid
  end

  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should validate_presence_of(:password_confirmation) }

  it "is invalid when the password and password_confirmation don't match" do
    user                       = FactoryGirl.build(:user)
    user.password              = 'foobar'
    user.password_confirmation = 'bazbat'
    user.should_not be_valid
  end

  describe '#open_account_with!' do
    it 'creates an account with the other other' do
      user       = FactoryGirl.create(:user)
      other_user = FactoryGirl.create(:user)
      expect { user.open_account_with!(other_user) }.
        to change(user.accounts, :size).by(1)
    end
  end

  describe '#close_account_with!' do
    it 'destroys the account shared with the other user' do
      user       = FactoryGirl.create(:user)
      other_user = FactoryGirl.create(:user)
      user.open_account_with!(other_user)
      expect { user.close_account_with!(other_user) }.
        to change(user.accounts, :size).by(-1)
    end
  end

  describe "#total_accounts" do
    it "counts the user's accounts and reverse accounts" do
      user = FactoryGirl.create(:user)
      user.open_account_with!(FactoryGirl.create(:user))
      FactoryGirl.create(:user).open_account_with!(user)
      user.total_accounts.should == 2
    end
  end

  describe '#to_s' do
    it "returns the user's name" do
      user.name = 'David'
      user.to_s.should == 'David'
    end
  end
end
