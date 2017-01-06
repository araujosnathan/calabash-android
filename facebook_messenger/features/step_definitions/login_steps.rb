######### GIVEN #########
Given(/^that i am on login screen$/) do
  @fb_messenger_welcomeScreen = page(WelcomerScreen).await(timeout:5)
  @fb_login_screen = @fb_messenger_welcomeScreen.continue
end

######### WHEN #########
When(/^i fill the email and password field with valid credentials$/) do
  @fb_login_screen.login(CONFIG['user'], CONFIG['pwd'])
end

When(/^i click on continue button$/) do
  @fb_login_screen.click_on_continue_button
end

When(/^i ignore upload info about my contacts$/) do
end

When(/^i ignore info about my phone number$/) do
  @fb_login_screen.skip_configs
end

When(/^i fill the email and password field with invalid credentials$/) do
  @fb_login_screen.login(CONFIG['invalidUser'], CONFIG['invalidPwd'])
end

######### THEN #########
Then(/^i should be redirect for messenger inicial screen$/) do
  @fb_login_screen.assert_messenger_screen_initial
end

Then(/^i should see the follow messange "([^"]*)"$/) do |arg1|
  @fb_login_screen.assert_invalid_user_login_messange
end
