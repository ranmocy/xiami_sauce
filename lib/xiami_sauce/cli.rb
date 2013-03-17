require 'thor'

module XiamiSauce
  class CLI < Thor
    default_task :download

    desc 'download URL', 'download the music from a page url.'
    def download(url=nil)
      unless url
        puts "Target Xiami URL[Song, Album, Artist, ShowCollect]:"
        url = gets.chomp
      end
      puts "Preparing to download #{url}."

      list = TrackList.new(url).download
    end

    def method_missing(url, *args)
      download(url)
    end

  end
end
