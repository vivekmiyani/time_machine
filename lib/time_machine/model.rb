require 'time_machine/model_config'

module TimeMachine
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def can_go_back_in_time(options = {})
        class_attribute :time_machine_model_config
        self.time_machine_model_config = ::TimeMachine::ModelConfig.new(self, options)
        self.time_machine_model_config.setup_callbacks
        self.time_machine_model_config.setup_association
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include TimeMachine::Model
end
