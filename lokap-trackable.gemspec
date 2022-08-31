# frozen_string_literal: true

require_relative "lib/lokap/trackable/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 2.6.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.name     = "lokap-trackable"
  spec.version  = Lokap::Trackable::VERSION
  spec.authors  = ["Adam Bair"]
  spec.email    = ["adambair@gmail.com"]

  spec.licenses = "Nonstandard"
  spec.summary  = "Tracks activities/events on ActiveRecord models"
  spec.homepage = "https://github.com/adambair/lokap-trackable"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "https://github.com/adambair/lokap-trackable/blob/master/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/adambair/lokap-trackable/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'lokap-verbs', '~> 3.1.1'
end
