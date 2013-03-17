require "spec_helper"

# should define :subject as TrackList
shared_context "parse to doc" do |url|
  before(:all) do
    track_list = XiamiSauce::TrackList.new
    @uri, @type = track_list.send(:parse_url, url)
    track_list.instance_variable_set("@uri", @uri)
    track_list.instance_variable_set("@type", @type)
    sleep(2)
    @doc = track_list.send(:parse_doc, @uri)
  end
  before(:each) do
    subject { XiamiSauce::TrackList.new }
    subject.instance_variable_set("@doc", @doc)
    # subject.stubs(:parse_doc).returns(@doc)
  end
end

# should define :subject as TrackList
shared_examples "a right parser" do |type, expected_result|
  let(:selector) { subject.send(:selector, type) }
  let(:parse_result) { subject.send(:parse_info_from_doc, selector) }
  it { expect(parse_result).to be_kind_of Array }
  it { expect(parse_result.first).to be_kind_of String }
  it { expect(parse_result.size).to be == expected_result }
end

describe XiamiSauce::TrackList do
  context "to parse doc" do
    let(:url) { 'http://www.xiami.com/song/1770450682' }
    subject { XiamiSauce::TrackList.new }

    it "should parse url" do
      uri, type = subject.send(:parse_url, url)
      uri.path.should == '/song/1770450682'
      type.should == :song
    end

    it "should parse doc" do
      uri, type = subject.send(:parse_url, url)
      subject.instance_variable_set("@uri", uri)
      subject.instance_variable_set("@type", type)
      doc = subject.send(:parse_doc, uri)
      subject.instance_variable_set("@doc", doc)
      subject.instance_variable_get("@doc").should be_kind_of Nokogiri::HTML::Document
    end
  end


  context "should support type song" do
    include_context "parse to doc", 'http://www.xiami.com/song/1770450682'
    it_should_behave_like "a right parser", "song", 1
  end

  context "should support type album" do
    include_context "parse to doc", 'http://www.xiami.com/album/462525'
    it_should_behave_like "a right parser", "album", 7
  end

  context "should support type artist" do
    include_context "parse to doc", 'http://www.xiami.com/artist/19775'
    it_should_behave_like "a right parser", "artist", 10
  end

  context "should support type showcollect" do
    include_context "parse to doc", 'http://www.xiami.com/song/showcollect/id/10100776'
    it_should_behave_like "a right parser", "showcollect", 50
  end


  context "doing operations" do
    let(:a_url) { 'http://www.xiami.com/album/355791' }
    let(:a_list) { XiamiSauce::TrackList.new(a_url) }
    let(:b_url) { 'http://www.xiami.com/album/362997' }
    let(:b_list) { XiamiSauce::TrackList.new(b_url) }

    it "should be able to add" do
      (a_list << b_list).list.should be == (a_list.list << b_list.list)
    end
  end
end
