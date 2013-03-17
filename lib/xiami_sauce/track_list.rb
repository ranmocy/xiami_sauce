require 'pathname'
require_relative 'track'
require 'nokogiri'

module XiamiSauce
  class URLParseError  < StandardError; end
  class DocParseError  < StandardError; end
  class InvalidURLType < StandardError; end

  class TrackList
    SONG_SELECTOR        = nil
    ALBUM_SELECTOR       = "div#track.album_tracks table.track_list tr td.song_name"
    ARTIST_SELECTOR      = "div#artist_trends table.track_list td.song_name"
    SHOWCOLLECT_SELECTOR = "div#list_collect div.quote_song_list li span.song_name"

    attr_accessor :list

    def initialize(url=nil)
      @list = []
      parse(url) if url
    end

    def parse(url)
      @uri, @type = parse_url(url)
      @doc        = parse_doc(@uri)
      urls        = parse_info_from_doc(selector(@type))
      @list       += urls.collect { |url| Track.new(url) }
      self
    end

    def download(target_path=nil)
      path = (target_path && Pathname.new(target_path.to_s).exists?) || Pathname.new("./")

      puts "Downloading #{@list.size} tracks..."
      count = @list.uniq!.inject(0) do |count, track|
        count += 1 if track.download
      end
      puts "Downloaded #{count}/#{@list.size} tracks."
      count
    end


    def to_a
      @list
    end

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
      raise DocParseError, e.message
    end

    def parse_info_from_doc(selector)
      return [@uri.to_s] unless selector
      @doc.css(selector).collect { |element| element.css("a").first["href"] }
    end

    def selector(type)
      selector_name = "#{type.to_s.upcase}_SELECTOR"
      unless self.class.const_defined?(selector_name)
        raise InvalidURLType, "#{type} isn't a supported URL type. Check your URL."
      end
      self.class.const_get(selector_name)
    end

  end
end
