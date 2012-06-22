require 'spec_helper'

describe "Txn pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    @account = FactoryGirl.create :account, user: user
    sign_in user
  end

  describe 'txn creation' do
    before { visit root_path }

    describe 'with invalid information' do
      it 'shoud not create a txn' do
        expect { click_button 'Create' }.should_not change(Txn, :count)
      end

      describe 'error messages' do
        before { click_button 'Create' }
        it { should have_content('error') }
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'txn_date',                with: Date.today
        fill_in 'txn_description',         with: 'Lorem ipsum'
        fill_in 'txn_amount',              with: 1200
        select  @account.other_party_name,  from: 'txn_account_id'
      end

      it 'should create a txn' do
        expect { click_button 'Create' }.should change(Txn, :count).by(1)
      end
    end
  end

  describe 'txn destruction' do
    before { FactoryGirl.create(:txn, user: user) }

    describe 'as correct user' do
      before { visit root_path }

      it 'should delete a txn' do
        expect { click_link 'delete' }.should change(Txn, :count).by(-1)
      end
    end
  end
end
