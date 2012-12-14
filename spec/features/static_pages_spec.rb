require 'spec_helper'

describe 'Static pages' do
  let(:base_title) { 'D Owes D' }

  subject { page }

  it 'should have the right links on the layout' do
    visit root_path
    click_link 'About'
    page.should have_title(full_title('About'))
    click_link 'Contact'
    page.should have_title(full_title('Contact'))
  end

  shared_examples_for 'all static pages' do
    it { should have_title(full_title(page_title)) }
    it { should have_selector 'h1', text: heading }
  end

  describe 'Home page' do
    describe 'when not signed in' do
      let(:heading)    { 'D Owes D' }
      let(:page_title) { 'Home' }

      before { visit root_path }

      it_should_behave_like 'all static pages'
    end

    describe 'for signed-in users' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        visit root_path
      end

      it { should have_title(full_title('My Accounts')) }
    end
  end

  describe 'About page' do
    before { visit about_path }

    let(:heading)    { 'About' }
    let(:page_title) { 'About' }

    it_should_behave_like 'all static pages'
  end

  describe 'Contact page' do
    before { visit contact_path }

    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like 'all static pages'
  end
end
