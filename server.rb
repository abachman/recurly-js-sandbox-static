require 'sinatra'
require 'sinatra/cors'
require 'json'

set :allow_origin, "*"
set :allow_methods, "POST"
set :allow_headers, "content-type"
set :expose_headers, "content-type"
set :default_content_type, "application/json"

HAS_PRIVATE_KEY = !ENV['RECURLY_PRIVATE_KEY'].nil?

get '/' do
  "POST /purchase { token: {} }\nHAS_PRIVATE_KEY=#{HAS_PRIVATE_KEY.inspect}"
end

post '/purchase' do
  request.body.rewind
  payload = JSON.parse(request.body.read)

  if payload['token']
    status 200
    body JSON.generate({ accept: true, HAS_PRIVATE_KEY: HAS_PRIVATE_KEY })
  else
    status 400
    body JSON.generate({ accept: false, HAS_PRIVATE_KEY: HAS_PRIVATE_KEY })
  end
end

