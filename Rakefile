require File.dirname(__FILE__) + "/lib/facilitation_patterns"
require 'spec/rake/spectask'

task :default => [:spec, :generate, "test:links"]

task :clean do
  rm_rf "public"
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

def new_site
  site = ActionSite::Site.new(File.dirname(__FILE__) + "/web", File.dirname(__FILE__) + "/public")
  
  site.generators["pattern"] = Generators::PatternGenerator.new
  site.generators["red"] = Generators::RedclothWithPatternsGenerator.new
  
  site.context.patterns = Patterns.load("web")
  site.context.patterns_by_category = {}
  site.context.patterns.each do |pattern|
    (site.context.patterns_by_category[pattern.category] ||= []) << pattern
  end
  
  site
end

desc "generate the site"
task :generate do
  new_site.generate
end

desc "start serving the site on http://localhost:3000/"
task :start do
  new_site.serve
end

desc "test links"
task "test:links" do
  server = Thread.new(new_site) {|site| site.serve(3334)}
  sleep 1

  links = ActionSite::AsyncLinkChecker.new
  links.check("http://localhost:3334/")
  
  server.kill
end
