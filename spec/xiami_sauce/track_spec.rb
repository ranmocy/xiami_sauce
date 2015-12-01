require 'spec_helper'

describe XiamiSauce::Track do
  let(:song_url) { "http://www.xiami.com/song/1770361274" }
  let(:index) { 9 }

  subject { XiamiSauce::Track.new(song_url, index) }

  it { expect(subject.id).to be == '1770361274' }
  it { expect(subject.index).to be == '9' }
  it { expect(subject.name).to be == 'Kids (Unedited Version)' }
  it { expect(subject.album_id).to be == '454588' }
  it { expect(subject.album_cover).to be == 'http://img.xiami.com/./images/album/img68/11768/4545881311563810_3.jpg' }
  it { expect(subject.album_name).to be == 'The Way I Am' }
  it { expect(subject.artist_id).to be == '11768' }
  it { expect(subject.artist_name).to be == 'Eminem' }

  it { expect(subject.file_name).to be == '[Eminem-The Way I Am]09.Kids (Unedited Version).mp3' }

  it { expect(subject.url).to be == 'http://f1.xiami.net/11768/454588/02_1770361274_2491919.mp3' }
end
