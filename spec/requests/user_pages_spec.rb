require 'spec_helper'

describe 'User pages' do
  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  describe 'index' do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: 'Bob', email: 'bob@example.com')
      FactoryGirl.create(:user, name: 'Ben', email: 'ben@example.com')
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    it 'should list each user' do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end

  describe 'profile page' do
    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_selector('title', text: user.name) }
    it { should have_selector('h1',    text: user.name) }
  end

  describe 'edit' do
    before do
      sign_in user
      visit edit_user_path(user)
    end

    it { should have_selector('title', text: 'Edit user') }
    it { should have_selector('h1',    text: 'Update your profile') }
    it { should have_link('change', href: 'http://gravatar.com/emails') }

    describe 'with invalid information' do
      before { click_button 'Save changes' }

      it { should have_content('error') }
    end

    describe 'with valid information' do
      let(:new_name)  { 'New Name' }
      let(:new_email) { 'new@example.com' }

      before do
        fill_in 'Name',             with: new_name
        fill_in 'Email',            with: new_email
        fill_in 'Password',         with: user.password
        fill_in 'Confirm Password', with: user.password
        click_button 'Save changes'
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
