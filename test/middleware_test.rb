require "test_helper"
require "rack"
require_relative "../lib/roger_autoprefixer/middleware"

module RogerAutoprefixer
  class MiddlewareTest < ::Test::Unit::TestCase
    def build_stack(file, options = {})
      fixture = File.read(File.dirname(__FILE__) + "/fixtures/" + file)

      # Always respond with the file contents in this little app
      app = proc { [200, {
        "Content-Type" => "text/css"
        }, [fixture]] }

      stack = Middleware.new(app, options)
      Rack::MockRequest.new(stack)
    end

    def test_middleware_processor
      response = build_stack("flex.css").get("/javascripts/src/test.js")
      assert response.body.include?("-webkit-flex;")
      assert_equal response.status, 200
    end
  end
end
