# TrialDay

## Running

`bundle exec rackup --port 3000`

### Curl lines

`curl http://localhost:3000/bla -i`

`curl -XPOST http://localhost:3000/bla -i -H "Content-Type: application/json" -d '{"name": "Mario"}'`

## Running Tests

`bundle exec rake test`
