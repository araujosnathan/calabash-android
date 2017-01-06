class WelcomerScreen < AndroidScreenBase
  # The screen identificator
   trait(:trait)                 { "* text:'#{layout_name}'" }

  # Declare all the elements of this screen
  element(:layout_name)               { "Welcome to Messenger" }
  element(:button_continue)           { 'login_group' }


  # Declare all actions of this screen
  def continue
    touch("* id:'#{button_continue}'")
    page(LoginScreen)
  end
end
