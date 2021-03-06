require File.dirname(__FILE__) + "/./transformer"
require "rack/response"

module RogerAutoprefixer
  # Middleware
  # Rack middleware to transform from unprefixed css to css with vendor prefixes
  class Middleware
    # @option options [Array] :skip Array of regexp Skip certain URL's
    # @option options [Array] :browsers Browsers to do autporefixing for passed to AutoprefixerRails
    def initialize(app, options = {})
      @app = app
      @options = {
        skip: [],
        browsers: nil
      }.update(options)
    end

    def call(env)
      status, headers, body = @app.call(env)

      if status == 200 && headers["Content-Type"].to_s.include?("text/css") && !@options[:skip].detect { |r| r.match(env["PATH_INFO"]) }
        body_str = []
        body.each { |f| body_str << f }
        body_str = body_str.join

        # This is a dirty little hack to always enforce UTF8
        body_str.force_encoding("UTF-8")

        prefixer_options = {
          from: env["PATH_INFO"]
        }

        prefixer_options[:browsers] = @options[:browsers] if @options[:browsers]

        Rack::Response.new(Transformer.instance.transform(body_str, prefixer_options), status, headers).finish
      else
        [status, headers, body]
      end
    end
  end
end
