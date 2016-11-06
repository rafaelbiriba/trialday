require "json"
require "insensitive_hash"

def resources
  @resources ||= {}
end

["get", "post"].each do |method|
  define_method method do |path, &block|
    (resources[path] ||= {}).merge!({ method => block })
  end
end

def start
  routes = {}
  resources.each do |resource, action|
    routes[resource] = Proc.new do |env|
      request = Rack::Request.new(env)
      response_200(request, action)
    end
  end
  run Rack::URLMap.new routes
end

def response_200 request, action
  params = request.params.insensitive
  response = action[request.request_method.downcase]
  [200, {"Content-Type" => "application/json"}, [response.call(params).to_json]]
end
