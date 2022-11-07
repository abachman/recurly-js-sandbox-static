## Running static client site locally

This is a single page purchase form demonstrating Recurly.js w/ fraud detection enabled

Update `client/config.js` to point at localhost:

```js
window.recurlyConfig.purchaseUrl = "http://localhost:4567/purchase";
```

Run with `npx serve`:

```sh
$ npx serve client/
```

## Running /purchase API locally

This is a tiny [Sinatra + Recurly](https://sinatrarb.com/) merchant application that accepts a payment token and creates an invoice.

Run as a docker image:

```sh
$ docker build --tag rjs-static .
$ docker run -p 4567:4567 rjs-static
```

run as a local ruby process:

```sh
$ bundle install
$ bundle exec ruby server.rb
```

or with puma:

```sh
$ bundle exec puma -p 4567
```
