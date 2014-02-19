module HtmlMockupAutoprefixer
  class Middleware
    def initialize(app, options={})
      @app = app
      @options = {
        :skip => []
      }.update(options)
    end

    def call(env)
      status, headers, body = @app.call(env)
      
      if status == 200 && headers["Content-Type"].to_s.include?("text/css") && !@options[:skip].detect{|r| r.match(env["PATH_INFO"]) }
        body_str = []
        body.each{|f| body_str << f }
        body_str = body_str.join
        
        # This is a dirty little hack to always enforce UTF8
        body_str.force_encoding("UTF-8")
      
        Rack::Response.new(AutoprefixerRails.compile(body_str), status, headers).finish
      else
        [status, headers, body]
      end
    end
  end
end