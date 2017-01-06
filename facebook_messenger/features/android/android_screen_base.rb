require 'calabash-android/abase'

class AndroidScreenBase < Calabash::ABase
  def self.element(element_name, &block)
    define_method(element_name.to_s, *block)
  end

  class << self
    alias_method :value, :element
    alias_method :action, :element
    alias_method :trait, :element
  end

  def restart_app
    shutdown_test_server
    start_test_server_in_background
  end

  def method_missing(method, *args)
    if method.to_s.start_with?('touch_')
      # If method name starts with touch_, executes the touch
      # screen element method using the element name which is the
      # method name without the first 'touch_' chars
      touch_screen_element public_send(method.to_s.sub('touch_', ''))
    elsif method.to_s.start_with?('enter_')
      # If method starts with enter_, execute the enter method using
      # the field name, which is the method name without the initial
      # 'enter_' chars and appended '_field' chars
      enter args[0], public_send("#{method.to_s.sub('enter_', '')}_field")
    elsif method.to_s.end_with?('_visible?')
      # If method ends with _visible?, executes the visible? method
      # The field name is the method name without de ending
      # '_visible? chars
      visible? public_send(method.to_s.sub('_visible?', ''))
    elsif method.to_s.end_with?('_visible!')
      # Do the same as the method above, but throws an exception
      # if the field is not visible
      field_name = method.to_s.sub('_visible!', '')
                         .sub('_field', '')
                         .sub('_', ' ')
                         .capitalize
      raise ElementNotFoundError, "ID: #{field_name}" unless
        visible? public_send(method.to_s.sub('_visible!', ''))
    else
      super(method, args)
    end
  end

  def visible?(id, query = nil)
    query = "* id:'#{id}'" if query.nil?
    begin
      wait_for(timeout: 3) { element_exists query }
    rescue
      return false
    end
    true
  end

  element(:loading_screen)      { 'insert_loading_view_id' }

  # The progress bar of the application is a custom view
  def wait_for_progress
    sleep(2)
    wait_for_element_does_not_exist("* id:'#{loading_screen}'",
                                    timeout: 10)
  end

  def drag_to(direction)
    positions = [0, 0, 0, 0] # [ 'from_x', 'to_x', 'from_y', 'to_y' ]

    case(direction)
    when :down
      positions = [30,30,60,30]
    when :up
      positions = [80,80,60,90]
    when :left
      positions = [90,20,80,80]
    when :right
      positions = [20,90,80,80]
    else
      raise 'Direction not known!'
    end

    # perform_action( 'action', 'from_x', 'to_x', 'from_y', 'to_y',
    # 'number of steps (in this case, velocity of drag' )
    perform_action('drag', positions[0], positions[1],
                   positions[2], positions[3], 15)
    sleep(1)
  end

  def drag_until_element_is_visible_with_special_query(direction, element)
    drag_until_element_is_visible direction, element,
                                  "* {text CONTAINS[c] '#{element}'}"
  end

  def drag_until_element_is_visible(direction, element, query = nil, limit = 15)
    i = 0

    element_query = ''
    if query.nil?
      element_query = "* marked:'#{element}'"
    else
      element_query = query
    end

    sleep(2)
    while !element_exists(element_query) && i < limit
      drag_to direction
      i += 1
    end

    fail "Executed #{limit} moviments #{direction} and "\
          "the element '#{element}' was not found on this view!" unless
      i < limit
  end

  def drag_for_specified_number_of_times(direction, times)
    times.times do
      drag_to direction
    end
  end

  # Negation indicates that we want a page that doesn't
  # has the message passed as parameter
  def is_on_page?(page_text, negation = '')
  fail 'Error! Invalid query string!' if
       page_text.to_s == ''

    should_not_have_exception = false
    should_have_exception = false
    begin
      wait_for(timeout: 5) { has_text? page_text }
      # If negation is not nil, we should raise an error
      # if this message was found on the view
      should_not_have_exception = true unless negation == ''
    rescue
      # only raise exception if negation is nil,
      # otherwise this is the expected behaviour
      should_have_exception = true if negation == ''
    end

    fail "Unexpected Page. The page should not have: '#{page_text}'" if
      should_not_have_exception

    fail "Unexpected Page. Expected was: '#{page_text}'" if
      should_have_exception
  end

  def enter(text, element, query = nil)
    if query.nil?
      query("* marked:'#{element}'", setText: text.to_s)
    else
      query(query, setText: text.to_s)
    end
  end

  def touch_screen_element(element, query = nil)
    query = "* id:'#{element}'" if query.nil?
    begin
      wait_for(timeout: 5) { element_exists(query) }
      touch(query)
    rescue => e
      raise "Problem in touch screen element: '#{element}'\nError Message: #{e.message}"
    end
  end

  def touch_element_by_index(id, index)
    wait_for(timeout: 5) { element_exists("* id:'#{id}' index:#{index}") }
    touch("* id:'#{id}' index:#{index}")
  end

  def clear_text_field(field)
    clear_text_in("android.widget.EditText id:'#{field}'}")
  end

  def select_date_on_date_picker(date, date_picker_field_id)
    # Touch the date picker field
    touch "* id:'#{date_picker_field_id}'"

    # Setting the date
    set_date 'DatePicker', date.year, date.month, date.day

    # Clicking in the Done button
    touch "* id:'button1'"
  end
end
