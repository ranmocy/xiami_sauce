require "cgi"
require 'net/http'
require 'nokogiri'
require_relative 'downloader'

module XiamiSauce
  class Track
    attr_accessor :id, :index, :name, :location, :url
    attr_accessor :album_id, :album_cover, :album_name
    attr_accessor :artist_id, :artist_name
    # user_id is who use the widget, could be 0.
    # attr_accessor :user_id, :width, :height, :widgetCode

    # @todo I wish index could be fetch automatically from somewhere.
    def initialize(song_url, index=nil)
      @id = song_url.match(/song\/([0-9]+)/)[1]
      @index = index.to_s

      parse_info
    end

    def download(parent_path=nil)
      file = Pathname('.').join((parent_path || album_name), url.split('/').last)
      @downloader = Downloader.new(url, file)
      @downloader.download
    end

    def file_name
      index_string = index ? index.to_s.rjust(2, '0') + '.' : ''
      "[#{artist_name}-#{album_name}]#{index_string}#{name}.mp3"
    end

    def info_src
      @info_src ||= "http://www.xiami.com/widget/xml-single/uid/0/sid/#{id}"
    end


    private

    def parse_info
      uri  = URI.parse(info_src)
      site = Net::HTTP.new(uri.host, uri.port)
      xml  = site.get2(uri.path,{'accept' => 'text/html', 'user-agent' => 'Mozilla/5.0'}).body
      doc  = Nokogiri::XML(xml)

      doc.css('track *').each do |element|
        instance_variable_set("@#{element.name}", element.content)
      end
      @name        = @song_name
      @url         = sospa(@location)
    end

    # Rewrite the algorithm, much much more better.
    def sospa(location)
      string    = location[1..-1]
      col       = location[0].to_i
      row       = (string.length.to_f / col).floor
      remainder = string.length % col
      address   = [[nil]*col]*(row+1)

      sizes = [row+1] * remainder + [row] * (col - remainder)
      pos = 0
      sizes.each_with_index { |size, i|
        size.times { |index| address[col * index + i] = string[pos + index] }
        pos += size
      }

      address = CGI::unescape(address.join).gsub('^', '0')
    rescue
      raise location
    end

  end
end
