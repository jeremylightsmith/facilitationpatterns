require File.dirname(__FILE__) + "/lib/facilitation_patterns"
require 'spec/rake/spectask'

task :default => [:spec, :generate, "test:links"]

task :clean do
  rm_rf "public"
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "generate the site"
task :generate do
  Dir.chdir(File.dirname(__FILE__)) do
    site = ActionSite::Site.new("web", "public")
    
    site.generators["pattern"] = Generators::PatternGenerator.new
    site.generators["red"] = Generators::RedclothWithPatternsGenerator.new
    
    site.context.patterns = Patterns.load("web")
    site.context.patterns_by_category = {}
    site.context.patterns.each do |pattern|
      (site.context.patterns_by_category[pattern.category] ||= []) << pattern
    end
    
    site.generate
  end
end

desc "open the site"
task :open do
  `open public/index.html`
end

desc "test links"
task "test:links" do
  links = ActionSite::LinkChecker.new
  links.check("http://localhost/facilitation_patterns/")
end

desc "test local links"
task "test:local_links" do
  links = ActionSite::LinkChecker.new(:local => true)
  links.check("http://localhost/facilitation_patterns/")
end
