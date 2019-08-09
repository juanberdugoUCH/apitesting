module TestHelpers
  # This module contains methods related to download
  module Download
    TIMEOUT = 3
    PATH    = File.absolute_path(File.join('tmp', 'downloads'))
    EXT     = '*.csv'
    PDF     = '*.pdf'
    extend self

    # @return [Array<String>] all the downloaded file names
    def downloads
      Dir[PATH + '/' + EXT]
    end

    # @return [String] the first file in the downloads list
    def download
      downloads.first
    end

    # @return [String] the content of the file returned by `download`
    def download_content
      wait_for_download
      File.read(download)
    end

    def wait_for_download
      Timeout.timeout(TIMEOUT) do
        sleep 1 until downloaded?
      end
    end

    def downloaded?
      !downloading? && downloads.any?
    end

    def downloading?
      downloads.grep(/\.part$/).any?
    end

    # Removes all the downloaded files
    def clear_downloads
      FileUtils.rm_f(downloads)
    end

    # @return [Array<String>] all the downloaded file names
    def pdf_downloads
      Dir[PATH + '/' + PDF]
    end

    # @return [String] the first file in the downloads list
    def pdf_download
      pdf_downloads.first
    end

    def pdf_downloading?
      pdf_downloads.grep(/\.part$/).any?
    end

    def pdf_downloaded?
      !pdf_downloading? && pdf_downloads.any?
    end
  end
end
