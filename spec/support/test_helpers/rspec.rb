module TestHelpers
  module Rspec
    def message(text, result)
      puts "• #{text}: #{result}"
    end

    def self.include_YAML(*path)
      YAML.load(ERB.new(File.read(File.join('spec', 'data', environment_fixture, path) + '.yml')).result.to_yaml)
    end

    def self.environment_fixture
      ENV['ENVIRONMENT'].to_s.empty? ? 'staging' : ENV['ENVIRONMENT']
    end
  end
end
