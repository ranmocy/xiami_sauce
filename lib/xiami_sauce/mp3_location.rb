require "cgi"

module XiamiSauce
  class Mp3
    attr_reader :url, :index, :track, :album, :artist

    def initialize(song_url, index=nil)
      @song_id = song_url.match(/song\/([0-9]+)/)[1]
      @index = index

      parse_info
    end

    def file_name
      "[#{artist}-#{album}]#{index.to_s.rjust(2, '0')}.#{track}.mp3"
    end

    private

    def parse_info
      info_src = "http://www.xiami.com/widget/xml-single/uid/0/sid/#{@song_id}"
      url_str = URI.parse(info_src)
      site = Net::HTTP.new(url_str.host, url_str.port)
      xml = site.get2(url_str.path,{'accept'=>'text/html'}).body
      doc = Nokogiri::XML(xml)
      @track = doc.at_css("song_name").content
      @album = doc.at_css("album_name").content
      @artist = doc.at_css("artist_name").content
      location = doc.at_css("location").content
      @url = sospa(location)
    end

    def sospa(location)
      totle = location.to_i
      new_str = location[1..-1]
      chu = (new_str.length.to_f / totle).floor
      yu = new_str.length % totle
      stor = []

      i = 0
      while i<yu do
        index = (chu+1)*i
        length = chu+1
        stor[i] = new_str[index...index+length]

        i+=1
      end


      i = yu
      while i<totle do
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
