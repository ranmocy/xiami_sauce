require 'fileutils'
require 'pathname'

module XiamiSauce
  class Downloader
    RETRY_TIMES = 3
    SLEEP_TIME  = 3

    attr_accessor :url, :file

    def initialize(url, file)
      @url  = url
      @file = file
    end

    def download
      FileUtils.mkdir_p(@file.parent) unless @file.parent.exist?

      puts "Downloading #{@file}."
      return puts 'Skip.'.color(:yellow) if @file.exist?

      retry_count = RETRY_TIMES
      begin
        raise unless(download_file url, @file)
      rescue Exception => e
        if retry_count == 0
          puts 'Failed.'.color(:red)
        else
          puts "Retry remain #{retry_count -= 1} times.".color(:yellow)
          sleep(SLEEP_TIME)
          retry
        end
      end

      puts 'Done.'.color(:green)
      sleep(SLEEP_TIME)
    end

    def check_file file_path
      /MPEG/.match(`file -b \"#{file_path}\"`)
    end

    def check_downloader
      return :curl if system('which curl >/dev/null')
      return :wget if system('which wget >/dev/null')
      raise 'No available downloader, currently support curl and wget.'
    end

    def download_file url, filename=nil
      puts "[Debug] DownloadFile::Params #{url}, #{filename}" if $DEBUG

      remote = url && url.to_s.gsub("\"", "\\\\\"")
      local  = filename && filename.to_s.gsub("\"", "\\\\\"")
      puts "[Debug] DownloadFile::Prepare #{remote}, #{local}" if $DEBUG

      case check_downloader
      when :curl
        command = local ? ("curl -\# \"%s\" > \"%s\"" % [remote, local]) : ("curl -O %s" % remote)
      when :wget
        command = local ? ("wget -O \"%s\" \"%s\"" % [local, remote]) : ("wget %s" % remote)
      end

      puts "[Debug] DownloadFile: #{command}" if $DEBUG
      system(command) && check_file(local)
    end

  end
end
