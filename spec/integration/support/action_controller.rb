# gives us more visibility in the stack trace in the log if something goes wrong
ActionController::Base.class_eval do
  puts 'Monkey Patching ActionController to give us stack traces in the test log; functionality copied from Cucumber'
  cattr_accessor :allow_rescue
end

class ActionDispatch::ShowExceptions
  alias __cucumber_orig_call__ call

  def call(env)
    env['action_dispatch.show_exceptions'] = !!ActionController::Base.allow_rescue
    __cucumber_orig_call__(env)
  end
end
ActionController::Base.allow_rescue = true

