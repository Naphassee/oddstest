require 'rails_helper'

RSpec.feature "Todos Management", type: :feature do
  before do
    @todo1 = Todo.create!(title: "First Quest")
    @todo2 = Todo.create!(title: "Second Quest")
  end

  it "User sees existing todos" do
    visit root_path
    expect(page).to have_content("First Quest")
    expect(page).to have_content("Second Quest")
  end

  it "shows profile and brags button" do
  visit root_path
  expect(page).to have_content("NAPHAS SEENAKASA")
  expect(page).to have_link("VIEW MY BRAGS", href: brags_path)
  end

  it "shows todo list when quests exist" do
    Todo.create!(title: "First Quest")
    visit root_path
    expect(page).to have_content("First Quest")
  end

  it "User adds a new quest" do
    visit root_path
    fill_in "Title", with: "New Quest"
    click_button "+ add"
    expect(page).to have_content("New Quest")
  end

  it "User tries to add a quest without title and sees validation error" do
    visit root_path

    fill_in "todo_title", with: ""
    click_button "+ add"

    expect(page).to have_content("Title can't be blank")

    expect(page).not_to have_selector("#todos li", text: "")
  end

  it "User deletes a quest" do
    visit root_path
    within("#todo_#{@todo1.id}") do
      click_button "Delete"
    end
    expect(page).not_to have_content("First Quest")
  end

  it "shows todo as checked when completed" do
    visit root_path
    within("#todo_#{@todo1.id}") do
      find("input[type=checkbox]").set(true)
      expect(find("input[type=checkbox]")).to be_checked
    end
  end

  it "User clicks VIEW MY BRAGS and navigates to brags page" do
    visit root_path
    click_link "VIEW MY BRAGS"
    expect(current_path).to eq(brags_path)
    expect(page).to have_content("GOALS FOR 2025")
  end
end
