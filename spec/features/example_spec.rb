# frozen_string_literal: true

require 'spec_helper'

describe 'Search on google', type: :feature do
  let(:page) { PageObjects::Youtube::Main.go_to_youtube }


  it "Search a video" do
    page.search_video('4k video')
    expect(page.has_video_searched?).to be_truthy
  end
end