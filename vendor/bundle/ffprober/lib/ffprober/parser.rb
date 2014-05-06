module Ffprober
  class Parser

    class ParserError < StandardError; end

    DEFAULT_TIMEOUT = 30
    DEFAULT_OPTIONS = '-v quiet -print_format json -show_format -show_streams'
    FRAMES_OPTIONS =  '-v quiet -print_format json -show_format -show_streams -show_frames -select_streams v:0 -read_intervals %+#10'

# ffprobe -v quiet -print_format json -show_format -show_streams -show_frames -select_streams v:0 -read_intervals 0.2%0.7 'https://esp-dev-oregon.s3-us-west-2.amazonaws.com/submission/assets/batch_1370/1387207704570_720x576_25_Progressive_Photo-JPEG-SDPreview.mov?AWSAccessKeyId=AKIAJAUDHVKKCZ5H4C6A&Signature=O31QTW1EKHfAo/h/eKWkCF1fzGI%3D&Expires=1387389719'

    class << self

      attr_accessor :options, :timeout

      def from_file(file_to_parse)
        unless FfprobeVersion.valid?
          raise ArgumentError.new("no or unsupported ffprobe version found.\
                                  (version: #{FfprobeVersion.new.version.to_s})")
        end

         #JRuby '`' will choke on non UTF-8 characters
        io_object = IO.popen("timeout #{timeout} #{Ffprober.path} #{options} '#{file_to_parse}'", 'r:binary')
        raw_output = io_object.read

        io_object.close

        exit_status = $?
        raise ParserError unless exit_status.success?

        json_output = raw_output.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

        from_json(json_output)
      end

      def from_json(json_to_parse)
        parser = self.new
        parser.parse(json_to_parse)
        parser
      end
    end

    def parse(json_to_parse)
      raise ArgumentError.new("No JSON found") if json_to_parse.nil?
      @json_to_parse = json_to_parse
    end

    def parsed_json
      @parsed_json ||=  begin
                          json = JSON.parse(@json_to_parse, symbolize_names: true)
                          raise InvalidInputFileError.new("Invalid input file") if json.empty?
                          json
                        end
    end

    def format
      @format ||= Ffprober::Format.new(parsed_json[:format])
    end

    def video_streams
      @video_streams ||= stream_by_codec('video').map { |s| Ffprober::VideoStream.new(s) }
    end

    def video_frames
      @video_frames ||= frame_by_media_type('video').map { |f| Ffprober::Frame.new(f) }
    end

    def audio_streams
      @audio_streams ||= stream_by_codec('audio').map { |s| Ffprober::AudioStream.new(s) }
    end

    def stream_by_codec(codec_type)
      streams.select { |stream| stream[:codec_type] == codec_type }
    end

    def frame_by_media_type(media_type)
      frames.select { |frame| frame[:media_type] == media_type }
    end

    def streams
      parsed_json[:streams]
    end

    def frames
      parsed_json[:frames]
    end
  end

  Parser.options = Ffprober::Parser::FRAMES_OPTIONS
  Parser.timeout = Ffprober::Parser::DEFAULT_TIMEOUT

end
