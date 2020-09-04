require 'time_machine/version'
require 'time_machine/model'
require 'time_machine/controller'
require 'time_machine/active_record/version'
require 'request_store'

module TimeMachine

  class << self
    def store
      RequestStore.store[:time_machine] ||= {}
    end
  end
end
