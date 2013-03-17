require 'fileutils'
require 'pathname'
require 'net/http'
require 'thor'
require_relative 'cli_helper'

module XiamiSauce
  class CLI < Thor
    default_task :download

    include CLIHelper

    desc 'download URL', 'download the music from a page url.'
    def download(url=nil)
      unless url
        puts "Target Xiami URL[Song, Album, Artist]:"
        url = gets.chomp
      end
      puts "Prepare to download #{url}."


      list = FetchList.new(url).get

      list.each_with_index do |song_url,index|
        mp3 = Mp3.new(song_url, index+1)
        path = Pathname.new(mp3.album)
        FileUtils.mkdir_p(path) unless path.exist?
        mp3_file = path.join(mp3.file_name)

        puts "Downloading #{mp3_file} #{index+1}/#{list.length}."
        if mp3_file.exist?
          puts 'Skip.'
          next
        end

        retry_count = RETRY_TIMES
        begin
          raise unless(download_file mp3.url, mp3_file)
        rescue Exception => e
          if retry_count == 0
            puts 'Failed.'
          else
            retry_count -= 1
            puts "Retry remain #{retry_count} times."
            sleep(5)
            retry
          end
        end

        puts 'Done.'
        sleep(rand(5)+5)
      end
    end

    def method_missing(url, *args)
      download(url)
    end

  end
end
