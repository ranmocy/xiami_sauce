require 'nokogiri'
require_relative 'track'

module XiamiSauce
  class URLParseError < StandardError; end
  class FetchDocError < StandardError; end

  class TrackList
    attr_accessor :uri, :type, :list, :doc

    def initialize(url)
      @uri  = URI.parse(url)
      @type = @uri.path.split('/')[1].to_sym
      @list = []
    rescue Exception => e
      raise URLParseError, e.message
    end

    def fetch_doc
      site = Net::HTTP.new(@uri.host, @uri.port)
      xml = site.get2(@uri.path, {'accept'=>'text/html', 'user-agent'=>'Mozilla/5.0'}).body
      @doc = Nokogiri::HTML(xml)
    rescue Exception => e
      raise FetchDocError, e.message
    end

    def get
      fetch_doc

      @list += send("parse_#{@type}")

      case @url
      when /album/
        @list += parse_album(@doc)
      when /showcollect/
        @list += parse_showcollect(@doc)
      when /artist/
        @list += parse_artist(@doc)
      when /song/
        @list << @url
      else
        raise "Invalid Url"
      end
      @list
    end

    def length
      @list.length
    end


    private

    def parse_album
      doc.css("div[id='track'] table.track_list tr").collect do |element|
        element.at_css("td.song_name a")["href"]
      end
    end

    def parse_showcollect
      doc.css("div[id='list_collect'] div.quote_song_list li .song_name").collect do |element|
        element.css("a").first["href"]
      end
    end

    def parse_artist
      doc.css("table.track_list td.song_name").collect do |element|
        element.css("a").first["href"]
      end
    end

    def parse_song
      [@uri.to_s]
    end

  end
end
