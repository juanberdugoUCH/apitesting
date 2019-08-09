# frozen_string_literal: true

module PageObjects
  module Youtube
    class Main < SitePrism::Page
      set_url 'https://www.youtube.com'

      element :search_input, 'input[id=search]'
      element :search_button, '#search-icon-legacy'
      element :video_searched, 'a',
              text: '4K VIDEO ultrahd hdr sony 4K VIDEOS demo test nature relaxation movie for 4k oled tv'

      def search_video(term)
        search_input.send_keys(term)
        search_button.click
      end

      def self.go_to_youtube
        load_page = Main.new
        load_page.load
        load_page
      end
    end
  end
end

