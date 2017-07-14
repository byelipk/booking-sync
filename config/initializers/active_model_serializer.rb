# 1. Set the adapter type
ActiveModelSerializers.config.adapter = :json_api

# 2. We will do key transformations on the client
ActiveModelSerializers.config.key_transform = :unaltered

# 3. Register the JSON API renderer to properly handle responses
ActiveSupport.on_load(:action_controller) do
  require 'active_model_serializers/register_jsonapi_renderer'
end
