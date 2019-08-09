require 'rspec/core/rake_task'
require 'net/http'
require 'uri'
require 'json'
require 'dotenv'

Dotenv.overload '.env'

task default: ENV['TASK']
namespace :qa do
  desc "Run Browser tests on Browserstack ENV['BROWSERS'] is required. See Readme"
  task :acceptance_tests do
    if ENV['BROWSERS'].nil? || ENV['BROWSERS'].empty?
      send_request(driver: ENV['DRIVER'] || 'headless_chrome')
    else
      driver = 'remote'
      browsers = ENV['BROWSERS'].split
      os = browsers.delete_at(-1)

      browsers.each do |browser|
        begin
          response = send_request(driver: driver, browser: browser, os: os)
          puts response.code
          puts response.body
        rescue => e
          puts e.backtrace.join("\n")
        end
      end
    end
  end

  def send_request(driver: '', browser: '', os: '')
    raise "Specify a Feature to test like FEATURE=NOTE-319 or FEATURE=* to run all features" unless ENV['FEATURE']

    uri = URI.parse("https://circleci.com/api/v1/project/everfi/courses_capybara?circle-token=#{ENV['CIRCLE_TOKEN']}")
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = JSON.dump({
        'build_parameters' => {
          'OS' => name(os),
          'OS_VERSION' => version(os),
          'BROWSER_NAME' => name(browser),
          'BROWSER_VERSION' => version(browser),
          'RESOLUTION' => ENV['RESOLUTION'],
          'DRIVER' => driver,
          'BROWSERSTACK_USERNAME' => ENV['BROWSERSTACK_USERNAME'],
          'BROWSERSTACK_KEY' => ENV['BROWSERSTACK_KEY'],
          'ENVIRONMENT' => ENV['ENVIRONMENT'],
          'FEATURE' => ENV['FEATURE']
        }
    })

    puts "Sending parameters to CircleCI: #{request.body}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  end

  def name(param)
    param.match(/\D+/).to_s
  end

  def version(param)
    (param.downcase == 'osx') ? 'High Sierra' : param.match(/\d+/).to_s
  end
end

desc 'Run end_to_end scenarios + features.'
task :e2e_and_features do
  spec_name = "spec/end_to_end/*.rb spec/features/*.rb spec/features/**/*.rb spec/features/**/**/*.rb"
  exec("bundle exec rspec #{spec_name} --format documentation --format RspecJunitFormatter -o ~/rspec/rspec.xml")
end

task :wip do
  if ENV['FEATURE'].to_s.empty?
    spec_name = "spec/wip/*.rb"
  else
    spec_name = "spec/wip/#{ENV['FEATURE']}.rb"
  end
  if ENV["TAG"].to_s.empty?
    exec("bundle exec rspec #{spec_name} --format documentation --format RspecJunitFormatter -o ~/rspec/rspec.xml")
  else
    exec("bundle exec rspec #{spec_name} --tag #{ENV["TAG"]} --format documentation --format RspecJunitFormatter -o ~/rspec/rspec.xml")
  end
end

task :regression do
  spec_name = "spec/features/*.rb spec/features/**/*.rb"
  if ENV["TAG"].to_s.empty?
    exec("bundle exec rspec #{spec_name}  --format documentation --format RspecJunitFormatter -o ~/rspec/rspec.xml")
  else
    exec("bundle exec rspec #{spec_name} --tag #{ENV["TAG"]} --format documentation --format RspecJunitFormatter -o ~/rspec/rspec.xml")
  end

end
