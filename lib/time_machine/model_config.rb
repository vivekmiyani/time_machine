module TimeMachine
  class ModelConfig

    def initialize(model, options)
      @model = model
      @options = options
      @options[:only] = (@options[:only] || []).map{|v| v.to_s}
      @options[:on] ||= %i[create update destroy]
      @options[:serializer_args] ||= nil
    end

    def setup_callbacks
      on.each do |event|
        public_send "on_#{event}"
      end
    end

    def setup_association
      model.has_many :versions, class_name: 'TimeMachine::Version', as: :original_object
    end

    def on_create
      model.after_create do |object|
        if object.time_machine_model_config.create_version?(object)
          Version.create(original_object: object,
                         action: 'create',
                         serialized_user: ::TimeMachine.store[:current_user].to_json,
                         serialized_object: object.to_json(object.time_machine_model_config.serializer_args),
                         serialized_object_changes: object.time_machine_model_config.notable_changes(object).to_json)
        end
      end
    end

    def on_update
      model.after_update do |object|
        if object.time_machine_model_config.create_version?(object)
          Version.create(original_object: object,
                         action: 'update',
                         serialized_user: ::TimeMachine.store[:current_user].to_json,
                         serialized_object: object.to_json(object.time_machine_model_config.serializer_args),
                         serialized_object_changes: object.time_machine_model_config.notable_changes(object).to_json)
        end
      end
    end

    # TODO: Needs work
    def on_destroy
      model.after_destroy do |object|
        if object.time_machine_model_config.create_version?(object)
          Version.create(original_object: object,
                         action: 'destroy',
                         serialized_user: ::TimeMachine.store[:current_user].to_json,
                         serialized_object: object.to_json(object.time_machine_model_config.serializer_args),
                         serialized_object_changes: object.time_machine_model_config.notable_changes(object).to_json)
        end
      end
    end

    def create_version?(object)
      (only & object.previous_changes.keys).present?
    end

    def notable_changes(object)
      object.previous_changes
    end

    def model
      @model
    end

    def only
      @options[:only]
    end

    def on
      @options[:on]
    end

    def serializer_args
      @options[:serializer_args]
    end
  end
end
