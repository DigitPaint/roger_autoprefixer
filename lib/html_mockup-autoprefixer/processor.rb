module HtmlMockupAutoprefixer
  class Processor
    # @option options [Array] :match An array of shell globs, defaults to ["stylesheets/**/*.scss"]
    # @option options [Array] :skip An array of regexps which will be skipped, defaults to [/_.*\.scss\Z/], Attention! Skipped files will be deleted as well!
    def call(release, options={})
      options = {
        :match => ["stylesheets/**/*.css"],
        :skip => []
      }.update(options)
  
      match = options.delete(:match)
      skip = options.delete(:skip)
  
      # Prefix CSS files
      files = release.get_files(match)
      files.each do |f|
        if !skip.detect{|r| r.match(f) }
          release.log(self, "Processing: #{f}")          
          # Compile SCSS
          content = File.read(f)
          File.open(f, "w") do |fh|
            fh.write AutoprefixerRails.compile(content)
          end
        end        
      end
    end    
  end
end