require 'spec_helper'

describe "Collections" do
  let(:user) { FactoryGirl.create(:user) }
  it "should create them" do
    login_as(user)
    visit root_path
    click_link "Get Started"
    click_link "Collections"
    click_button "Create Collection"
    expect(page).to have_content "Create New Collection"
    fill_in 'Title', with: 'amalgamate members'
    fill_in 'Description', with: "I've collected a few related things together"
    click_button "Create Collection"
    within 'table tbody' do
      expect(page).to have_content 'amalgamate members'
    end
  end
end