module Generators
  class PatternGenerator
    def process(context, content)
      name = File.basename(context.file_name).gsub(/\.pattern\.(xml|yml)/, '')

      context.pattern = context.patterns[name.to_sym]
      context.layout :pattern
      content = context.process_file(context.layout_template, context, false)
      context.layout :application
      content
    end
  end
end
