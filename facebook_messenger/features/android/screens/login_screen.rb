class LoginScreen < AndroidScreenBase
  # The screen identificator
   trait(:trait)                 { "* id:'#{layout_name}'" }

  # Declare all the elements of this screen
  element(:layout_name)                 { 'login_logo1' }
  element(:edit_email)                  { 'email' }
  element(:edit_password)               { 'password' }
  element(:button_login)                { 'login' }
  element(:invalid_user_messange)       { 'Please enter the email or phone number and password you use to log into Facebook.'}
  element(:button_skip_manage_contacts) { 'skip' }
  element(:button_skip_phone_number)    { 'skip_step' }
  element(:button2_skip_phone_number)   { 'button2' }
  element(:title_messenger)             { 'title'}

  # Declare all actions of this screen
  def login(user, pwd)
    touch("* id:'#{edit_email}'")
    enter_text("* id:'#{edit_email}'", user)
    touch("* id:'#{edit_password}'")
    enter_text("* id:'#{edit_password}'", pwd)
  end

  def click_on_continue_button
    touch("* id:'#{button_login}'")
  end

  def skip_configs
    wait_for_element_exists("* id:'#{button_skip_manage_contacts}'", timeout:7)
    touch("* id:'#{button_skip_manage_contacts}'")
    touch("* id:'#{button_skip_phone_number}'")
    touch("* id:'#{button2_skip_phone_number}'")
  end

  def assert_messenger_screen_initial
    wait_for_element_exists("* id:'#{title_messenger}'", timeout: 10)
  end

  def assert_invalid_user_login_messange
    wait_for_element_exists("* text:'#{invalid_user_messange}'", timeout:10)
  end

end
