Given(/^I am signed out$/) do
  page.driver.delete destroy_user_session_path
end

Given(/^I am signed in$/) do
  user = create :user, email: 'test@example.com', password: 'letmein123', password_confirmation: 'letmein123'
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button 'Sign in'
end

Then(/^I should be told to sign in$/) do
  expect(page).to have_content('You need to sign in or sign up before continuing.')
end
