module TimeMachine
  module Controller

    private

    def set_time_machine_user
      ::TimeMachine.store[:current_user] = current_user
    end
  end
end

::ActiveSupport.on_load(:action_controller) do
  include TimeMachine::Controller
end
