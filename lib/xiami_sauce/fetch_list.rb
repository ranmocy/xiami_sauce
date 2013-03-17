require 'nokogiri'

module XiamiSauce
  class FetchList
    attr :uri, :type, :list, :doc

    def initialize(url)
      @uri  = URI.parse(url)
      @type = @uri.path.split('/')[1].to_sym
      @list = []
    rescue
      raise "URL parse error"
    end

    def get_doc
      site = Net::HTTP.new(@uri.host, @uri.port)
      xml = site.get2(@uri.path, {'accept'=>'text/html', 'user-agent'=>'Mozilla/5.0'}).body
      @doc = Nokogiri::HTML(xml)
    end

    def get
      get_doc

      if type = :song
        @list << @uri.to_s
      else
        @list += "parse_#{}"
      end

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

    def parse_album(doc)
      doc.css("div[id='track'] table.track_list tr").collect do |element|
        element.at_css("td.song_name a")["href"]
      end
    end

    def parse_showcollect(doc)
      doc.css("div[id='list_collect'] div.quote_song_list li .song_name").collect do |element|
        element.css("a").first["href"]
      end
    end

    def parse_artist(doc)
      doc.css("table.track_list td.song_name").collect do |element|
        element.css("a").first["href"]
      end
    end

  end
end
