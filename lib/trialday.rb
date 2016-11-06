require "json"

def get path, &block
end

def post path, &block
  app = Proc.new do |env|
  request = Rack::Request.new(env)
    if request.post?
      [200, {"Content-Type" => "application/json"}, [{"name": request.params["name"]}.to_json]]
    else
      [200, {"Content-Type" => "application/json"}, [{"results": [1, 2, 3]}.to_json]]
    end
  end

  run Rack::URLMap.new({"/bla" => app})
end
