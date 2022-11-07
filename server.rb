require 'sinatra'
require 'sinatra/cors'
require 'json'
require 'securerandom'
require 'recurly'

set :allow_origin, "*"
set :allow_methods, "POST"
set :allow_headers, "content-type"
set :expose_headers, "content-type"
set :default_content_type, "application/json"

RECURLY_PRIVATE_KEY = ENV['RECURLY_PRIVATE_KEY']
HAS_PRIVATE_KEY = !RECURLY_PRIVATE_KEY.nil?

$recurly = nil
if HAS_PRIVATE_KEY
  puts "connecting Recurly client with key #{RECURLY_PRIVATE_KEY.gsub(/./, '*')}"
  $recurly = Recurly::Client.new(
    api_key: RECURLY_PRIVATE_KEY
  )
end

get '/' do
  "POST /purchase { token: {} }\nHAS_PRIVATE_KEY=#{HAS_PRIVATE_KEY.inspect}"
end

post '/purchase' do
  request.body.rewind
  payload = JSON.parse(request.body.read)

  if payload['token']
    begin
      purchase = {
        currency: "USD",
        account: {
          code: SecureRandom.uuid,
          billing_info: {
            token_id: payload['token']['id']
          },
        },
        subscriptions: [
          { plan_code: "in-the-box" }
        ]
      }
      invoice_collection = $recurly.create_purchase(
        body: purchase
      )

      puts "got invoice!"
      puts invoice_collection.inspect

      status 200
      body JSON.generate({ accept: true, success: true, HAS_PRIVATE_KEY: HAS_PRIVATE_KEY })
    rescue Recurly::Errors::ValidationError => e
      # If the request was invalid, you may want to tell your user
      # why. You can find the invalid params and reasons in e.recurly_error.params
      puts "ValidationError: #{e.recurly_error}"

      status 400
      body JSON.generate({ accept: true, success: false, HAS_PRIVATE_KEY: HAS_PRIVATE_KEY, error: e.recurly_error.params })
    rescue Recurly::Errors::TransactionError => e
      puts "TransactionError: #{e.recurly_error}"

      status 400
      body JSON.generate({ accept: true, success: false, HAS_PRIVATE_KEY: HAS_PRIVATE_KEY, error: e.recurly_error.message })
    end

  else
    status 400
    body JSON.generate({ accept: false, HAS_PRIVATE_KEY: HAS_PRIVATE_KEY })
  end
end

