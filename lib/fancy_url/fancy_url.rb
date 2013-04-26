# stolen code from
# https://scribdtech.wordpress.com/2010/09/01/vanity-user-profile-urls-in-rails/
module FancyUrl
  extend self

  def generate_cached_routes
    # Find all route we use
    @cached_routes = Rails.application.routes.routes.map {|route|
      route.path.spec.to_s.split('(').first.split('/').second
    }.compact.uniq

    # Remove routes whose first path component is a variable or wildcard
    @cached_routes.reject! { |route|
      route.starts_with?(':') or route.starts_with?('*') }

    # Remove the default rails route
    @cached_routes.delete 'rails'
    @cached_routes
  end

  def cached_routes
    @cached_routes || self.generate_cached_routes
  end

  def valid_for_short_url?(slug)
    not (slug.include?('.') or self.cached_routes.include?(slug))
  end
end
