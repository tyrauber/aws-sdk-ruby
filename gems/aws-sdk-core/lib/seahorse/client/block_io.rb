module Seahorse
  module Client
    class BlockIO

      def initialize(&block)
        @block = block
        @size = 0
      end

      # @param [String] chunk
      # @return [Integer]
      def write(chunk)
        @block.call(chunk)
        if chunk.respond_to?(:bytesize)
          chunk.bytesize.tap { |chunk_size| @size += chunk_size }
        else
          # count events in an eventstream
          1.tap { |event_count| @size += event_count }
        end
      end

      # @param [Integer] bytes (nil)
      # @param [String] output_buffer (nil)
      # @return [String, nil]
      def read(bytes = nil, output_buffer = nil)
        data = bytes ? nil : ''
        output_buffer ? output_buffer.replace(data || '') : data
      end

      # @return [Integer]
      def size
        @size
      end

    end
  end
end
