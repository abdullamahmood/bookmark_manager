ENV["RACK_ENV"] ||= "development"
require 'sinatra/base'
require 'sinatra/flash'

require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super_secret'
  register Sinatra::Flash

  get '/' do
  	redirect '/links'
  end

  get '/links' do
  	@links = Link.all
  	erb :'links/index'
  end

  get '/links/new' do
  	erb :'links/new'
  end

  post '/links' do
    link = Link.create(url: params[:url], title: params[:title])
    params[:tags].split(',').each do |name|
      name.strip!
      tag = Tag.first_or_create(name: name)
      LinkTag.create(link: link, tag: tag)
    end
    #link.tags << tag
    #link.save
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
   # if !session[:password_confirmation].nil?
   #   @password = session[:password]
   #   @password_confirmation = session[:password_confirmation]
   # end
   @user = User.new
   erb :'users/new'
  end

  post '/users' do
    @user = User.create(email: params[:email],
                      password: params[:password],
                      password_confirmation: params[:password_confirmation])

    if @user.save
      session[:user_id] = @user.id
      redirect '/links'
    else
      flash.now[:notice] = "Password and confirmation password do not match"
      erb :'users/new'
    end
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end




  run! if app_file == $0
end
