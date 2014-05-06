module Ffprober
  class Frame
    attr_accessor :media_type, :key_frame, :pkt_pts, :pkt_pts_time, :pkt_dts, :pkt_dts_time,
                  :pkt_duration, :pkt_duration_time, :pkt_pos, :pkt_size, :width, :height, :pix_fmt,
                  :pict_type, :coded_picture_number, :display_picture_number, :interlaced_frame,
                  :top_field_first, :repeat_pict

    def initialize(object_attribute_hash)
      object_attribute_hash.each {|k,v| instance_variable_set("@#{k}",v)}
    end

    def interlaced?
      self.interlaced_frame == 1
    end

    def progressive?
      self.interlaced_frame == 0
    end

  end
end
