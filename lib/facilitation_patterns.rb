$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

begin
  require 'rubygems'
  gem 'jeremylightsmith-actionsite', '>= 0.4'
rescue Exception
  $: << File.dirname(__FILE__) + "/../../actionsite/lib"
end
require 'action_site'

require 'pattern'
require 'patterns'
require 'pattern_links_extension'

require 'generators/pattern_generator'
require 'generators/redcloth_with_patterns_generator'
