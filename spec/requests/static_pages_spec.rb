require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "D Owes D" }

  describe "Contact page" do

    it "should have the title 'Contact'" do
      visit '/static_pages/contact'
      page.should have_selector('title', text: "#{base_title} | Contact")
    end

    it "should have the h1 'Contact'" do
      visit '/static_pages/contact'
      page.should have_selector('h1', text: 'Contact')
    end

  end

end
