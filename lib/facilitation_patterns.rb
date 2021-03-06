$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

begin
  require 'rubygems'
  gem 'jeremylightsmith-actionsite', '>= 0.6.2'
rescue Exception
  $: << File.dirname(__FILE__) + "/../../actionsite/lib"
end
require 'action_site'

require 'pattern'
require 'patterns'
require 'pattern_links_extension'
require 'pattern_parser'

require 'generators/pattern_generator'
require 'generators/redcloth_with_patterns_generator'

require 'extensions/array'