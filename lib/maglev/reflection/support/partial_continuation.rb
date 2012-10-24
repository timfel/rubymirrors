class PartialContinuation
  attr_accessor :markerBlock, :partial

  def self.currentDomarkerBlock(block, markerBlock)
    if (marker = markerBlock.call).nil?
      raise RuntimeError, 'Marker not found when capturing partial continuation.'
    end
    return block.call to_offset_markerBlock(marker, 1, markerBlock)
  end

  def self.to_offset_markerBlock(method, offset, &block)
    idx = find_frame_for(method)
    partial = Thread.__partialContinuationFromLevel_to(3 + offset, idx)
    new.tap do |o|
      o.partial = partial
      o.markerBlock = block
    end
  end

  def self.find_frame_for(method)
    index = 1
    while frame = Thread.current.__frame_contents_at(index) do
      if frame[0] == method
        return level
      else
        level += 1
      end
    end
    nil
  end

  def call(arg = nil)
    marker = markerBlock.call
    if marker.nil?
      marker = Thread.current.__frame_contents_at(2).first
      frameIndex = 2
    else
      frameIndex = self.class.find_frame_for marker
    end
    Thread.current.__installPartialContinuation_atLevel_value partial, frameIndex, arg
  end

  alias [] call
end

def test_callcc
  PartialContinuation.currentDomarkerBlock
  currentDo: aBlock 
  markerBlock: [ self callbackMarker ]
end
