require 'uri'

# hack because we need binmode on the tempfile
class Chef
  class ServerAPI
    def binmode_streaming_request(path, headers = {}, &block)
      url = create_url(path)
      response, rest_request, return_value = nil, nil, nil
      tempfile = nil

      method = :GET
      method, url, headers, data = apply_request_middleware(method, url, headers, data)

      response, rest_request, return_value = send_http_request(method, url, headers, data) do |http_response|
        puts http_response
        if http_response.kind_of?(Net::HTTPSuccess)
          tempfile = binmode_stream_to_tempfile(url, http_response)
          tempfile.close
        end
      end

      tempfile
    end

    def binmode_stream_to_tempfile(url, response)
      file = ::Tempfile.new(['compliance-profile', '.tgz'])
      file.binmode # !!!

      stream_handler = StreamHandler.new(middlewares, response)

      response.read_body do |chunk|
        file.write(stream_handler.handle_chunk(chunk))
      end
      # file.close
      file
    end
  end
end
