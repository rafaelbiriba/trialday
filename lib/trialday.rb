require "json"

def resources
  @resources ||= {}
end

def get path, &block
  (resources[path] ||= {}).merge!({ "get" => block })
end

def post path, &block
  (resources[path] ||= {}).merge!({ "post" => block })
end

def start
  routes = {}
  resources.each do |resource, action|
    routes[resource] = Proc.new do |env|
      request = Rack::Request.new(env)
      if request.get?
        [200, {"Content-Type" => "application/json"}, [action["get"].call.to_json]]
      elsif request.post?
        [200, {"Content-Type" => "application/json"}, [action["post"].call.to_json]]
      end
    end
  end
  run Rack::URLMap.new routes
end
