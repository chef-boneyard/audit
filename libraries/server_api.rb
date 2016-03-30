# encoding: utf-8

require 'uri'

class Chef
  # we need to activate because we need binmode on the tempfile
  class ServerAPI
    def binmode_streaming_request(path, headers = {})
      url = create_url(path)
      tempfile = nil

      method = :GET
      method, url, headers, data = apply_request_middleware(method, url, headers, data)

      response, _rest_request, _return_value = send_http_request(method, url, headers, data) do |http_response|
        if http_response.is_a?(Net::HTTPSuccess)
          tempfile = binmode_stream_to_tempfile(url, http_response)
          tempfile.close
        end
      end

      return nil if response.is_a?(Net::HTTPRedirection)
      response.error! unless response.is_a?(Net::HTTPSuccess)

      tempfile
    end

    def binmode_stream_to_tempfile(_url, response)
      file = ::Tempfile.new(['compliance-profile', '.tgz'])
      file.binmode # !!!

      stream_handler = StreamHandler.new(middlewares, response)

      response.read_body do |chunk|
        file.write(stream_handler.handle_chunk(chunk))
      end
      file
    end
  end
end
