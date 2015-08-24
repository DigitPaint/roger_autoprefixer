require "roger/release"

module RogerAutoprefixer
  class Processor
    # @option options [Array] :match An array of shell globs, defaults to ["stylesheets/**/*.scss"]
    # @option options [Array] :skip An array of regexps which will be skipped, defaults to [/_.*\.scss\Z/], Attention! Skipped files will be deleted as well!
    # @option options [Array] :browsers  Browsers to do autporefixing for passed to AutoprefixerRails
    def call(release, options = {})
      options = {
        match: ["stylesheets/**/*.css"],
        skip: [],
        browsers: nil
      }.update(options)

      match = options.delete(:match)
      skip = options.delete(:skip)

      # Setup prefixer options
      prefixer_options = {}

      if options[:browsers]
        prefixer_options[:browsers] = options[:browsers]
      end

      # Prefix CSS files
      files = release.get_files(match)
      files.each do |f|
        if !skip.detect { |r| r.match(f) }
          release.log(self, "Processing: #{f}")
          # Compile SCSS
          content = File.read(f)
          File.open(f, "w") do |fh|
            fh.write AutoprefixerRails.process(content, prefixer_options.dup.update(from: f)).css
          end
        end
      end
    end
  end
end

Roger::Release::Processors.register(:autoprefixer, RogerAutoprefixer::Processor)
