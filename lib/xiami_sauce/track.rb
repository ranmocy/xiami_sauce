require "cgi"

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

    def file_name
      index_string = index ? index.to_s.rjust(2, '0') + '.' : ''
      "[#{artist_name}-#{album_name}]#{index_string}#{name}.mp3"
    end

    def info_src
      @info_src ||= "http://www.xiami.com/widget/xml-single/uid/0/sid/#{id}"
    end


    private

    # @todo should be refactoried by reflection pattern.
    def parse_info
      url_str = URI.parse(info_src)
      site    = Net::HTTP.new(url_str.host, url_str.port)
      xml     = site.get2(url_str.path,{'accept'=>'text/html'}).body
      doc     = Nokogiri::XML(xml)

      doc.css('track *').each do |element|
        instance_variable_set("@#{element.name}", element.content)
      end
      @name        = @song_name
      @url         = sospa(@location)
    end

    def sospa(location)
      totle   = location.to_i
      new_str = location[1..-1]
      chu     = (new_str.length.to_f / totle).floor
      yu      = new_str.length % totle
      stor    = []

      i = 0
      while i < yu do
        index = (chu+1)*i
        length = chu+1
        stor[i] = new_str[index...index+length]

        i+=1
      end


      i = yu
      while i < totle do
        index = chu*(i-yu)+(chu+1)*yu
        length = chu

        stor[i] = new_str[index...index+length]

        i+=1
      end

      pin_str = ""
      0.upto(stor[0].length-1) do |ii|
        0.upto(stor.length-1) do |jj|
          pin_str += stor[jj][ii...ii+1]
        end
      end

      pin_str = rtan(pin_str)
      return_str = ""

      0.upto(pin_str.length-1) do |iii|
        if pin_str[iii...iii+1]=='^'
          return_str<<"0"
        else
          return_str<<pin_str[iii...iii+1]
        end
      end

      return_str
    end

    def rtan(str)
      CGI::unescape(str)
    end
  end
end
