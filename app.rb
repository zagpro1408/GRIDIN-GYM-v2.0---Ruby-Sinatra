require 'rubygems'
require 'sinatra'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Гость'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb :index
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/schedule' do
  erb :schedule
end

get '/contacts' do
  erb :contacts
end

get '/aboutus' do
  erb :aboutus
end

get '/trainers' do
  erb :trainers
end

get '/free' do
  erb :free
end

post '/free' do

  @error = "Введите: "

  @name_input = params[:name_input]
  @phone_input = params[:phone_input]
  @trainer_input = params[:trainer_input]
  @email_input = params[:email_input]

  hh = { :name_input => "-имя ",
              :phone_input => "-телефон ",
              :email_input => "-email "
  }

hh.each do |key, value|
  if params[key] == ""
    @error += "#{hh[key]}"
  end
end

  if @error == "Введите: "
    f = File.open("public/users.txt", "a")
    f.write "\nUser: #{@name_input} \tPhone: #{@phone_input} \tTrainer: #{@trainer_input} \tEmail: #{@email_input}"
    f.close
    erb :free_done
  else
    erb :free
  end
end

##get '/secure/place' do
  ##erb 'This is a secret place that only <%=session[:identity]%> has access to!'
##end
