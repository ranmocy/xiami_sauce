require 'spec_helper'

describe XiamiSauce::Track do
  let(:song_url) { "http://www.xiami.com/song/1770361274" }
  let(:index) { 9 }

  subject { XiamiSauce::Track.new(song_url, index) }

  its('id') { should == '1770361274' }
  its('index') { should == '9' }
  its('name') { should == 'Kids (Unedited Version)' }
  its('url') { should == 'http://f1.xiami.net/11768/454588/02_1770361274_2491919.mp3' }
  its('album_id') { should == '454588' }
  its('album_cover') { should == 'http://img.xiami.com/./images/album/img68/11768/4545881311563810_3.jpg' }
  its('album_name') { should == 'The Way I Am' }
  its('artist_id') { should == '11768' }
  its('artist_name') { should == 'Eminem' }

  its('file_name') { should == '[Eminem-The Way I Am]09.Kids (Unedited Version).mp3' }
end
