%w(rubygems sinatra tropo-webapi-ruby awesome_print).each{|lib| require lib}

enable :sessions

post '/' do
     tropo_session = Tropo::Generator.parse(request.env["rack.input"].read)
     session['message_to_play'] = tropo_session['session']['parameters']['message']
     ap tropo_session          # LOG TO CONSOLE
          tropo = Tropo::Generator.new do
            on :event => 'hangup', :next => '/hangup.json'
            on :event => 'continue', :next => '/speak.json'
          call(:to=>"tel:+1" + tropo_session['session']['parameters']['number_to_dial'],:from => '4078350065')            
          end
  tropo.response
end

post '/speak.json' do
  msg = session['message_to_play']
  ap Tropo::Generator.parse(request.env["rack.input"].read)
  tropo = Tropo::Generator.new do
    on :event => 'hangup', :next => '/hangup.json'   
    say msg
  end
  tropo.response
end

post '/hangup.json' do
  json_string = request.env["rack.input"].read
  tropo_session = Tropo::Generator.parse json_string
  ap tropo_session
end

