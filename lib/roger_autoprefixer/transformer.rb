require "singleton"
require 'autoprefixer-rails'

# The transformer will take care of thread safe transformation of css without
# vendor prefixes -> css with vendor prefixes using autoprefixer.
# We need this to prevent deadlock in the V8 engine.
class Transformer
  include Singleton

  def initialize
    @mutex = Mutex.new
  end

  def transform(code, options)
    prefixer = nil
    @mutex.synchronize do
      prefixer = AutoprefixerRails.process(code, options)
    end
    prefixer.css
  end
end
