require 'sinatra'
require 'sinatra/cors'
require 'json'

set :allow_origin, "*"
set :allow_methods, "POST"
set :allow_headers, "content-type"
set :expose_headers, "content-type"
set :default_content_type, "application/json"

get '/' do
  'POST /purchase { token: {} }'
end

post '/purchase' do
  request.body.rewind
  payload = JSON.parse(request.body.read)

  if payload['token']
    status 200
    body JSON.generate({ accept: true })
  else
    status 400
    body JSON.generate({ accept: false })
  end
end

