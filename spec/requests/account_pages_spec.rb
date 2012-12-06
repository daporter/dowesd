require 'spec_helper'

describe 'Account pages' do
  let!(:user)       { FactoryGirl.create(:user, name: 'David') }
  let!(:other_user) { FactoryGirl.create(:user, name: 'Deciana') }
  let(:account)     { user.open_account_with!(other_user) }

  subject { page }

  describe 'index page' do
    before do
      FactoryGirl.create(:txn,
                         user:        user,
                         account:     account,
                         description: 'Foo',
                         amount:      5000)
      sign_in user
      visit user_accounts_path(user)
    end

    it { should have_selector('title', text: full_title('My Accounts')) }

    it do
      should have_selector('h1' , text: 'Accounts I\'ve Opened With Others')
    end

    it do
      should have_link(other_user.name, href: user_account_path(user, account))
    end

    it { should have_content("#{other_user.name} owes $50.00") }
  end

  describe 'index page when user is other party to account' do
    before do
      FactoryGirl.create(:txn,
                         user:        user,
                         account:     account,
                         description: 'Foo',
                         amount:      5000)
      sign_in other_user
      visit user_accounts_path(other_user)
    end

    it do
      should have_selector('h1' , text: 'Accounts Others Have Opened With Me')
    end

    it do
      should have_link(user.name, href: user_account_path(other_user, account))
    end

    it { should have_content('You owe $50.00') }
  end

  describe 'account page' do
    let!(:txn1) do
      FactoryGirl.create(:txn,
                         user:        user,
                         account:     account,
                         description: 'Foo',
                         amount:      5000)
    end
    let!(:txn2) do
      FactoryGirl.create(:txn,
                         user:        other_user,
                         account:     account,
                         description: 'Bar',
                         amount:      8000)
    end

    describe 'when current user is account user' do
      before do
        sign_in user
        visit user_account_path(user, account)
      end

      it { should have_selector('title', text: other_user.name) }
      it do
        should have_selector('h1', text: "Your Account with #{other_user.name}")
      end

      describe 'transactions' do
        it { should have_content(txn1.description) }
        it { should have_content(txn2.description) }
        it { should have_content(user.txns.count) }
      end

      describe 'balance' do
        it { should have_content('You owe $30.00') }
      end

      describe 'txn creation' do
        before { visit user_account_path(user, account) }

        describe 'with invalid information' do
          it 'should not create a txn' do
            expect { click_button 'Save' }.to_not change(Txn, :count)
          end

          describe 'error messages' do
            before { click_button 'Save' }
            it { should have_content('error') }
          end
        end

        describe 'with valid information' do
          before do
            fill_in 'txn_date',           with: Date.today
            fill_in 'txn_description',    with: 'Lorem ipsum'
            fill_in 'txn_amount_dollars', with: '12'
          end

          it 'should create a txn' do
            expect { click_button 'Save' }.to change(Txn, :count).by(1)
          end
        end
      end

      describe 'editing a txn' do
        before do
          visit user_account_path(user, account)
          click_link "edit-txn-#{txn1.id}"
        end

        it { should have_selector('title', text: 'Edit transaction') }

        describe 'submitting the update' do
          before do
            fill_in 'Description', with: 'updated-description'
            click_button 'Save'
          end

          it { should have_content('Transaction updated') }
          it { should have_selector("#txn-description-#{txn1.id}",
                                     text: 'updated-description') }
        end
      end

      describe 'txn destruction' do
        let(:delete_link) { "delete-txn-#{txn1.id}" }

        describe 'as correct user' do
          before { visit user_account_path(user, account) }

          it 'should delete a txn' do
            expect { click_link delete_link }.to change(Txn, :count).by(-1)
          end

          it do
            should have_selector('title',
                                 text: "Account with #{other_user.name}")
          end
        end
      end
    end

    describe 'when current user is account other party' do
      before do
        sign_in other_user
        visit user_account_path(other_user, account)
      end

      it { should have_selector('title', text: "Account with #{user.name}") }
      it { should have_selector('h1', text: "Your Account with #{user.name}") }
    end
  end
end
