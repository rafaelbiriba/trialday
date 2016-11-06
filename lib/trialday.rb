require "json"
require "insensitive_hash"

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
      params = request.params.insensitive
      if request.get?
        response_200(params, &action["get"])
      elsif request.post?
        response_200(params, &action["post"])
      end
    end
  end
  run Rack::URLMap.new routes
end

def response_200 params, &response
  [200, {"Content-Type" => "application/json"}, [response.call(params).to_json]]
end
