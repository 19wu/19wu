class FallbackUrlRedirector
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body =
      begin
        @app.call(env)
      rescue ActiveRecord::RecordNotFound
        if path = find_path(env)
          return [301, { 'Location' => path }, ["Redirecting you to #{path}"]]
        end
        raise
      end
    [status, headers, body]
  end


  private
  def find_path(env)
    path = env['PATH_INFO'].sub(/^\//, '')
    (path.present? && url = FallbackUrl.find_by_origin(path)) ? url.change_to : nil
  end
end
