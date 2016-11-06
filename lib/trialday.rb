require "json"
require "insensitive_hash"

def resources
  @resources ||= {}
end

["get", "post"].each do |method|
  define_method method do |path, &block|
    (resources[path] ||= {}).merge!({ method => block })
    build_routes
  end
end

def build_routes
  routes = {}
  resources.each do |resource, action|
    routes[resource] = create_resouce_action(action)
  end
  run Rack::URLMap.new routes
end

def create_resouce_action action
  Proc.new do |env|
    request = Rack::Request.new(env)
    response(request, action)
  end
end

def response request, action
  request_body = request.body.read
  params = JSON.parse(request_body).insensitive unless request_body.empty?
  response_block = action[request.request_method.downcase]
  if response_block.nil?
    response_501
  else
    response_200(response_block.call(params).to_json)
  end
end

def response_200 content
  [200, {"Content-Type" => "application/json"}, [content]]
end

def response_501
  [501, {"Content-Type" => "text/plain"}, ["Not Implemented"]]
end
