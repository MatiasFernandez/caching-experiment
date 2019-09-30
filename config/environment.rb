# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

module LogMiddleware
  def call(env)
    Rails.logger.debug "Starting #{self.class.name} middleware"
    result = super
    Rails.logger.debug "#{self.class.name} middleware Finished"
    result
  end
end

Rails.configuration.middleware.map(&:klass).each do |middleware|
  middleware.prepend LogMiddleware if middleware.respond_to?(:prepend)
end

Rails.application.routes.class.prepend LogMiddleware
Rack::Cache::Context.prepend LogMiddleware