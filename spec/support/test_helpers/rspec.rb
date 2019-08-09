module TestHelpers
  module Rspec
    def message(text, result)
      puts "• #{text}: #{result}"
    end

    def sleep_when_selenium
      sleep 0.8 if selenium?
    end

    def selenium?
      Capybara.current_driver == :selenium
    end

    def remote?
      Capybara.current_driver == :remote
    end

    def self.print_session_id_if_remote
      if Capybara.current_driver == :remote
        puts "• Session ID: #{Capybara.current_session&.driver&.browser&.session_id}"
        puts '• If this build was run on Browserstack you can search by above session id'
      end
    end

    def element_present?(selector, **options)
      return false unless selector
      !!all(selector, options)&.first
    end

    def click_if_present(selector, exact: true)
      if selector
        wait_for_delay_selector(selector)
        page.should have_selector(selector, visible: true, wait: 20) if (element_present? selector) || exact
        all(selector, visible: true)&.first&.click
      end
    end

    def self.include_YAML(*path)
      YAML.load(ERB.new(File.read(File.join('spec', 'data', environment_fixture, path) + '.yml')).result.to_yaml)
    end

    def self.environment_fixture
      ENV['ENVIRONMENT'].to_s.empty? ? 'staging' : ENV['ENVIRONMENT']
    end

    # Sleep for number of # seconds from class
    # .open-carousel-button.delay-3s => sleep 3 seconds
    def wait_for_delay_selector(selector)
      delay = selector.scan(/delay-\d*s/).map { |x| x[/\d+/] }.first.to_i
      delay += 1 if delay.zero?
      sleep delay
    end
  end
end
