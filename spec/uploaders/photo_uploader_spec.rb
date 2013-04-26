require 'carrierwave/test/matchers'

describe PhotoUploader do # http://git.io/XhkwBw
  include CarrierWave::Test::Matchers
  let(:photo) { Photo.new }

  before do
    PhotoUploader.enable_processing = true
    @uploader = PhotoUploader.new(photo, :image)
    @uploader.store!(File.open(path))
  end

  after do
    PhotoUploader.enable_processing = false
    @uploader.remove!
  end


  context 'the normal version' do
    context 'from big image' do
      let(:path) { Rails.root.join("spec/factories/data/event/map_big.png") } # 630 x 650
      it "should scale down a landscape image to fit with 620 pixels width" do
        @uploader.normal.should have_dimensions(620, 640) # http://j.mp/14rqhZk
      end
    end
    context 'from small image' do
      let(:path) { Rails.root.join("spec/factories/data/event/map.png") } # 284 x 347
      it "should not be scale down" do
        @uploader.normal.should have_dimensions(284, 347)
      end
    end
  end
end
