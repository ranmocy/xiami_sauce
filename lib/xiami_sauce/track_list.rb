require 'pathname'
require_relative 'track'
require 'nokogiri'

module XiamiSauce
  class URLParseError  < StandardError; end
  class FetchDocError  < StandardError; end
  class InvalidURLType < StandardError; end

  class TrackList
    attr_accessor :list

    def initialize(url=nil)
      @list = []
      parse(url) if url
    end

    def parse(url)
      @uri, @type = parse_url(url)
      @doc        = parse_doc(@uri)

      parse_method = "parse_from_#{@type}"
      unless respond_to? parse_method, true # true for search inside private methods
        raise InvalidURLType, "#{@type} isn't a supported URL type. Check your URL."
      end

      @list += send(parse_method).collect { |url| Track.new(url.to_s) }
      self
    end

    def download(target_path=nil)
      path = (target_path && Pathname.new(target_path.to_s).exists?) || Pathname.new("./")

      puts "Downloading #{@list.size} tracks..."
      count = @list.inject(0) do |count, track|
        count += 1 if track.download
      end
      puts "Downloaded #{count}/#{@list.size} tracks."
      count
    end


    def to_a
      @list
    end
    alias_method :to_ary, :to_a

    def method_missing(method_name, *args)
      @list.send(method_name, *args)
      self
    end


    private

    def parse_url(url)
      uri  = URI.parse(url)
      type = uri.path.split('/')[1].to_sym
      [uri, type]
    rescue Exception => e
      raise URLParseError, e.message
    end

    def parse_doc(uri)
      site = Net::HTTP.new(uri.host, uri.port)
      xml = site.get2(uri.path, {'accept' => 'text/html', 'user-agent' => 'Mozilla/5.0'}).body
      Nokogiri::HTML(xml)
    rescue Exception => e
      raise FetchDocError, e.message
    end


    def parse_from_album
      @doc.css("div#track.album_tracks table.track_list tr td.song_name").collect do |element|
        element.css("a").first["href"]
      end
    end

    def parse_from_showcollect
      @doc.css("div#list_collect div.quote_song_list li span.song_name").collect do |element|
        element.css("a").first["href"]
      end
    end

    def parse_from_artist
      @doc.css("div#artist_trends table.track_list td.song_name").collect do |element|
        element.css("a").first["href"]
      end
    end

    def parse_from_song
      [@uri.to_s]
    end

  end
end
