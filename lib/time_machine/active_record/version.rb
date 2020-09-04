module TimeMachine
  # Version schema:
  # original_object
  # action
  # serialized_user
  # serialized_object
  # serialized_object_changes
  class Version < ::ActiveRecord::Base
    default_scope -> { order(created_at: :desc) }

    belongs_to :original_object, polymorphic: true

    # TODO: Instead of using `OpenStruct` we can initialize the Model
    def user
      @user ||= JSON.parse self.serialized_user, object_class: OpenStruct
    end

    def object
      @object ||= JSON.parse self.serialized_object, object_class: OpenStruct
    end

    def object_changes
      @object_changes ||= JSON.parse self.serialized_object_changes, object_class: OpenStruct
    end
  end

  def self.table_name_prefix
    'time_machine_'
  end
end
