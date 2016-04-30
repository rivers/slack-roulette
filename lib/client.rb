require 'net/http'
require 'uri'
require 'cgi'
require 'json'

class Client
  SCOPES = %w(commands usergroups:read users:read)

  class << self
    def get(method, params = {})
      query_string = CGI.unescape(params.to_query)

      url = [path(method), query_string].join('?')
      uri = URI.parse(url)

      response = Net::HTTP.get_response(uri)

      JSON.parse(response.body)
    end

    def post(method, payload = {})
      uri = URI.parse(path(method))

      response = Net::HTTP.post_form(uri, payload)

      JSON.parse(response.body)
    end

    def path(method)
      "https://slack.com/api/#{method}"
    end

    def get_access_token(code)
      payload = {
        client_id:     client_id,
        client_secret: secret,
        code:          code,
        redirect_uri:  callback_url
      }

      post('oauth.access', payload)
    end

    def authorize_url
      [
        'https://slack.com/oauth/authorize',
        "scope=#{SCOPES.join(',')}&client_id=#{client_id}"
      ].join('?')
    end

    def callback_path
      '/oauth/callback'
    end

    def callback_url
      [ENV['BASE_URL'], callback_path].join
    end

    def client_id
      ENV['CLIENT_ID']
    end

    def secret
      ENV['CLIENT_SECRET']
    end
  end
end
