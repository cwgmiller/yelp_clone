require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have to be added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurant yet')
    end
  end

  context 'creating restaurants' do

    scenario 'user to fill out a form, then displays the new restaurant' do
      sign_up_user
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'a user has to be logged in' do
      visit '/'
      click_link 'Add a restaurant'
      expect(current_path).not_to eq '/restaurants/new'
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        sign_up_user
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
end
  end

  context 'viewing restaurants' do

    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do

    scenario 'let a user edit a restaurant' do
      sign_up_user
      create_restaurant
      visit '/'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    xscenario 'user can only edit a restaurant they have created' do
      sign_up_user
      create_restaurant
      click_link 'Sign out'
      sign_up_user('test@example.com', 'testtest')
      visit '/'
      click_link 'Edit KFC'
      expect(page).not_to have_content 'Update Restaurant'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do

    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_up_user
      create_restaurant
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    xscenario 'user can only delete a restaurant they have created' do
      sign_up_user
      create_restaurant
      click_link 'Sign out'
      sign_up_user('test@example.com', 'testtest')
      visit '/'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'Restaurant deleted successfully'
      expect(page).to have_content 'KFC'
    end
  end

  def sign_up_user(email = 'banana@example.com', password = 'bananatest')
    visit '/'
    click_link 'Sign up'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_button 'Sign up'
  end

  def create_restaurant
    visit '/'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
  end

end
