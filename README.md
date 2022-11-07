## Running locally

run as a docker image:

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
