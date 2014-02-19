module HtmlMockupAutoprefixer
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      if status == 200 && headers["Content-Type"].to_s.include?("text/css")
        body_str = []
        body.each{|f| body_str << f }
        body_str = body_str.join
      
        Rack::Response.new(AutoprefixerRails.compile(body_str), status, headers).finish
      else
        [status, headers, body]
      end
    end
  end
end