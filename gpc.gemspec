# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "gpc"
  spec.version = '0.1.0'
  spec.authors = ["Premysl Donat"]
  spec.email = ["pdonat@seznam.cz"]

  spec.summary = "Parser for ABO's GPC bank statements"
  spec.description = spec.summary
  spec.homepage = 'https://github.com/Masa331/gpc'
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "czech_bank_account"
end
