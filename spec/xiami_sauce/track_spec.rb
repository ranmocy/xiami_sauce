require 'spec_helper'

describe XiamiSauce::Track do
  let(:song_url) { "http://www.xiami.com/song/1770361274" }
  let(:index) { 9 }

  subject { XiamiSauce::Track.new(song_url, index) }

  it { subject.id.should == '1770361274' }
  it { subject.index.should == '9' }
  it { subject.name.should == 'Kids (Unedited Version)' }
  it { subject.album_id.should == '454588' }
  it { subject.album_cover.should == 'http://img.xiami.com/./images/album/img68/11768/4545881311563810_3.jpg' }
  it { subject.album_name.should == 'The Way I Am' }
  it { subject.artist_id.should == '11768' }
  it { subject.artist_name.should == 'Eminem' }

  it { subject.file_name.should == '[Eminem-The Way I Am]09.Kids (Unedited Version).mp3' }

  it { subject.url.should == 'http://f1.xiami.net/11768/454588/02_1770361274_2491919.mp3' }
end
