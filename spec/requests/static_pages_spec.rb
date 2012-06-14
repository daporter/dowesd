require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "D Owes D" }

  describe "About page" do
    it "should have the title 'About'" do
      visit about_path
      page.should have_selector('title', text: "#{base_title} | About")
    end

    it "should have the h1 'About'" do
      visit about_path
      page.should have_selector('h1', text: 'About')
    end
  end

  describe "Contact page" do
    it "should have the title 'Contact'" do
      visit contact_path
      page.should have_selector('title', text: "#{base_title} | Contact")
    end

    it "should have the h1 'Contact'" do
      visit contact_path
      page.should have_selector('h1', text: 'Contact')
    end
  end

end
