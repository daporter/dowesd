require "spec_helper"

describe User do
  before do
    @user = User.create(name:  "Example User",
                        email: "user@example.com",
                        password:              "foobar",
                        password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:txns) }
  it { should respond_to(:feed) }
  it { should respond_to(:accounts) }
  it { should respond_to(:other_parties) }
  it { should respond_to(:reverse_accounts) }
  it { should respond_to(:reverse_other_parties) }
  it { should respond_to(:has_account_with?) }
  it { should respond_to(:open_account_with!) }
  it { should respond_to(:close_account_with!) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      @user_with_same_email = @user.dup
      @user_with_same_email.email = @user.email.upcase
    end

    specify { @user_with_same_email.should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of #authenticate" do
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    its(:remember_token) { should_not be_blank }
  end

  describe "txn associations" do
    let!(:older_txn) { FactoryGirl.create(:txn, user: @user, date: 2.days.ago) }
    let!(:newer_txn) { FactoryGirl.create(:txn, user: @user, date: 1.day.ago) }

    it "should have the right txns in the right order" do
      @user.txns.should == [newer_txn, older_txn]
    end

    it "should destroy associated txns" do
      txns = @user.txns
      @user.destroy
      txns.each { |txn| Txn.find_by_id(txn.id).should be_nil }
    end

    describe "status" do
      let(:unshared_txn) do
        FactoryGirl.create(:txn, user: FactoryGirl.create(:user))
      end
      let(:user_sharing_account) { FactoryGirl.create(:user) }

      before do
        account = @user.open_account_with!(user_sharing_account)
        3.times do
          user_sharing_account.txns.create!(date:        Date.today,
                                            description: "Lorem",
                                            amount:      10,
                                            account_id:  account.id)
        end
      end

      its(:feed) { should include(newer_txn) }
      its(:feed) { should include(older_txn) }
      its(:feed) { should_not include(unshared_txn) }
      its(:feed) do
        user_sharing_account.txns.each { |txn| should include(txn) }
      end
    end
  end

  describe "opening an account" do
    let(:other_user) { FactoryGirl.create(:user) }
    before { @user.open_account_with!(other_user) }

    it { should have_account_with(other_user) }
    its(:other_parties) { should include(other_user) }
    specify { other_user.should have_account_with(@user) }
    specify { other_user.reverse_other_parties.should include(@user) }

    describe "and closing an account" do
      before { @user.close_account_with!(other_user) }

      it { should_not have_account_with(other_user) }
      its(:other_parties) { should_not include(other_user) }
    end
  end

  describe "#total_accounts" do
    before do
      @user.open_account_with!(FactoryGirl.create(:user))
      FactoryGirl.create(:user).open_account_with!(@user)
    end

    its(:total_accounts) { should == 2 }
  end

  describe '#to_s' do
    its(:to_s) { should == 'Example User' }
  end
end
