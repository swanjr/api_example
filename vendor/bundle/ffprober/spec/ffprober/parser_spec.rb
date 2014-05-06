# encoding: utf-8
require 'spec_helper'

describe Ffprober::Parser do

  describe "from_url", if: Ffprober::FfprobeVersion.valid? do

    let(:url) { 'https://esp-dev-oregon.s3-us-west-2.amazonaws.com/submission/assets/batch_1370/1387207704570_720x576_25_Progressive_Photo-JPEG-SDPreview.mov?AWSAccessKeyId=AKIAIZBFLJLTR7DAQPUA&Signature=5d59pDadGlC3v5MI2odkWZWoYT4%3D&Expires=1393027200' }
    let(:ffprobe) { Ffprober::Parser.from_file(url) }

    describe "format" do

      it "should determine the correct filename" do
        ffprobe.format.filename.should eq(url)
      end

      it "should find the correct size" do
        ffprobe.format.size.should eq("1077173")
      end

      it "should find the correct bit_rate" do
        ffprobe.format.bit_rate.should eq("336616")
      end
    end

  end

  describe "from_file", if: Ffprober::FfprobeVersion.valid? do

    context "with non-UTF-8 Metadata" do
      before :each do
        @ffprobe = Ffprober::Parser.from_file('spec/assets/non-utf-8.mov')
      end

      describe "format" do
        it "should strip all non-utf-8 characters" do
          @ffprobe.format.instance_variable_get(:@tags)[:title].should eq("Gestionnaire dalias Apple")
        end
      end
    end

    context "with UTF-8 Metadata" do
      before :each do
        @ffprobe = Ffprober::Parser.from_file('spec/assets/301-extracting_a_ruby_gem.m4v')
      end

      describe "format" do
        it "should determine the correct filename" do
          @ffprobe.format.filename.should eq("spec/assets/301-extracting_a_ruby_gem.m4v")
        end

        it "should find the correct size" do
          @ffprobe.format.size.should eq("130694")
        end

        it "should find the correct bit_rate" do
          @ffprobe.format.bit_rate.should eq("502669")
        end
      end
    end
  end

  describe "from invalid file", if: Ffprober::FfprobeVersion.valid? do

    describe "format" do

      it "should fail when parsing" do
        expect { Ffprober::Parser.from_file('spec/assets/empty_file') }.to raise_error
      end

    end
  end

  describe "from_json" do
    before :each do
      @ffprobe = Ffprober::Parser.from_json(File.read('spec/assets/301-extracting_a_ruby_gem_2.json'))
    end

    describe "format" do
      it "should determine the correct filename" do
        filename = "https://esp-dev-oregon.s3-us-west-2.amazonaws.com/submission/assets/batch_1370/1387207704570_720x576_25_Progressive_Photo-JPEG-SDPreview.mov?AWSAccessKeyId=AKIAJAUDHVKKCZ5H4C6A&Signature=O31QTW1EKHfAo/h/eKWkCF1fzGI%3D&Expires=1387389719"
        @ffprobe.format.filename.should eq(filename)
      end

      it "should find the correct size" do
        @ffprobe.format.size.should eq("1077173")
      end

      it "should find the correct bit_rate" do
        @ffprobe.format.bit_rate.should eq("336616")
      end
    end

    describe "audio_streams" do
      xit "should determine the correct number of audio streams" do
        @ffprobe.audio_streams.count.should eq(1)
      end

      xit "should determine the correct sample rate of the first audio stream" do
        @ffprobe.audio_streams.first.sample_rate.should eq("48000")
      end

    end

    describe "video_streams" do
      it "should determine the correct width of the first video streams" do
        @ffprobe.video_streams.first.width.should eq(480)
      end

      it "should determine the correct width of the first video streams" do
        @ffprobe.video_streams.first.height.should eq(360)
      end

      it "should determine the correct number of video streams" do
        @ffprobe.video_streams.count.should eq(1)
      end
    end

    describe "video_frames" do

      it "should determine the correct scan type" do
        @ffprobe.video_frames.first.progressive?.should be_true
      end

      it "should determine the correct number of video frames" do
        @ffprobe.video_frames.count.should eq(17)
      end
    end

  end

end
