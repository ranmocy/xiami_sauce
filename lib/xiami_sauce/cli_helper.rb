module CLIHelper

  RETRY_TIMES = 5

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
