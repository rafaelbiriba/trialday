require "trialday"

get "/bla" do
  { results: [1, 2, 3] }
end

post "/bla" do |params|
  name = params[:name]

  { name: name }
end

get "/bla2" do |params|
  {}
end
