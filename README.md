# Foundry Rspec and Capybara Acceptance Automation Tests
##### This is a set-up guide for MacOs
### Dependencies

  * Ruby (version in .ruby-version)
  
### Required Tools

  * Homebrew: Mac OS X package manager
    * `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
  * Safari: https://support.apple.com/downloads/safari
  * Firefox: https://www.mozilla.org/en-US/firefox/new
  * Chrome: https://www.google.com/chrome/

### Recommended Tools


  * Ack: better than grep
    * `brew install ack`

## Setup Guide

  * [Installation](#installation)
  * [Running the Tests](#running-the-tests)
  * [Updating Ruby](#updating-ruby)
  * [Infrastructure](#infrastructure)

---

## Installation

###  Homebrew Packages

Install rbenv (https://github.com/sstephenson/rbenv)

- brew install rbenv
- rbenv -v
- brew install ruby-build
- echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
This enables shims, which are necessary for passing standard ruby commands to your rbenv-managed Ruby environment.  To check if you already have it, open ~/.bash_profile (subl ~/.bash_profile if you have sublime)
- source ~/.bash_profile

Install ChromeDriver

- brew tap homebrew/cask
- brew cask install chromedriver

Install Ruby

- rbenv install 2.4.3
- rbenv global 2.4.3 (start using your install instead of the system version)
- ruby --version (Make sure it's 2.4.3. Restart Terminal and check again if you get something older)

Install Bundler

- gem install bundler
- rbenv rehash 



### Bundle

After cloning this repository, navigate to the ruby-capybara-framework directory in Terminal. Use bundler to install dependencies from the gemfile:

```bash
gem install bundler
rbenv rehash
bundle
```

### Environment variables
In your text editor, open the app folder and create a new file in the root of the folder called `.env`.
Copy the variables from `.env.sample`.
Each variable use is described in the [Running the Tests](#running-the-tests) section.

## Running the Tests
* Navigate to your test directory in Terminal (ruby-capybara-framework) before running commands.

### QA Local Rspec

#### With a Browser: (default):

Make sure you've run bundle command in ruby-capybara-framework folder (or used the brew commands under Installation above), and have chromedriver working.
Run tests from the root ruby-capybara-framework folder where spec_helper.rb is contained, so it can be found and loaded.
```bash
rspec spec/features/your_test_script_spec.rb
```
NOTE: some tests may need some extra adaptation to be run outside of an end_to_end test

To run a specific end_to_end spec use:
```bash
bundle exec rake end_to_end FEATURE=NOTE-319
```

To run all the end_to_end specs use:
```bash
bundle exec rake end_to_end FEATURE=*

or

bundle exec rake end_to_end
```

To run a specific test within an end_to_end spec use:
```bash
bundle exec rake end_to_end FEATURE=ECA-664 TAG=test
```
This requires the test's code to have the tag specified in the command


To run a specific suite, use:
```bash
rspec spec/features --tag group:*<<suite-name>>* --format documentation --format RspecJunitFormatter
```


#### Headless:
* Set the Environmental variables to use headless_chrome:

```bash
export BROWSER_NAME=''
export DRIVER=selenium
BROWSER_NAME=headless_chrome
rspec
```

#### Run with RubyMine:
Through RubyMine's Terminal, you may first need to:
```bash
export BROWSER_NAME=''
export DRIVER=selenium
```
Then, access Edit Configurations... -> Environment variables
```bash
BROWSER_NAME=chrome
DRIVER=selenium
```
