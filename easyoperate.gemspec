# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{easyoperate}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jinzhu Zhang"]
  s.date = %q{2008-12-30}
  s.default_executable = %q{eo}
  s.description = %q{Eo_oE}
  s.email = %q{wosmvp@gmail.com}
  s.executables = ["eo"]
  s.extra_rdoc_files = ["bin/eo", "lib/eo.rb", "lib/easyoperate.rb", "lib/eo/scm/git.rb", "lib/eo/scm/svn.rb", "lib/eo/eo.rb", "lib/eo/repository.rb", "lib/eo/gem.rb", "README.rdoc"]
  s.files = ["Manifest", "test/test_helper.rb", "test/test_eo_cli.rb", "test/test_easyoperate.rb", "bin/eo", "example/config", "example/repos", "Rakefile", "History.txt", "lib/eo.rb", "lib/easyoperate.rb", "lib/eo/scm/git.rb", "lib/eo/scm/svn.rb", "lib/eo/eo.rb", "lib/eo/repository.rb", "lib/eo/gem.rb", "README.rdoc", "easyoperate.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://www.zhangjinzhu.com}
  s.post_install_message = %q{[31m

 Attention Please ( <= v0.3.0 ):
   ~/.eorc renamed to ~/.eo/repos
   Add new config file ~/.eo/config

 
                  [0m}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Easyoperate", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{easyoperate}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Eo_oE}
  s.test_files = ["test/test_helper.rb", "test/test_eo_cli.rb", "test/test_easyoperate.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
