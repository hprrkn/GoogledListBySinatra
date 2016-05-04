require 'sinatra'
require 'active_record'
require 'logger'

configure do
  enable :sessions
  set :session_secret, "mysessionsecret"
end

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./googledword.db"
)

class User < ActiveRecord::Base
  has_many :words
  has_many :tags
end

class Word < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :users
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :words
  belongs_to :users
end

before do
  if request.url =~ %r{/login} then
  else
     if !session[:login] then
       @msg = "Please LogIn"
       redirect '/login'
     else
       @userId = session[:uId]
       @userWords = User.find(@userId).words
       @userTags = User.find(@userId).tags
     end
  end
end

get '/login' do
  erb :login
end

post '/login/check' do
  @user = User.where({:username => params[:username]}).first
  if @user.present? then
     if @user.password == params[:password] then
       session[:login] = true
       session[:uId] = @user.id
       redirect '/index'
       erb :index
     else
       redirect '/login'
       erb :login
     end
  else
    redirect '/login'
    erb :login
  end
end


get '/index' do
  @countOfMonth = @userWords.group("strftime('%Y-%m', created_at)").count.each
  @tags = @userTags.all
	erb :index
end

get %r{/list/(\d{4})\-(\d{2})} do |y,m|
  from = Date::new(y.to_i,m.to_i,1)
  to = from >> 1
  @words = @userWords.where("created_at >= ? AND created_at < ?", from.strftime("%Y-%m-%d"), to.strftime("%Y-%m-%d"))
  erb :list
end  

get %r{/detail/([0-9]*)} do |id| 
  @word = @userWords.find(id)
	erb :detail
end

get %r{/edit/([0-9]*)} do |id|
  @word = @userWords.find(id)
  @tags = @userTags.all
  erb :edit
end

get '/tag/list' do
  @tags = @userTags.all
  erb :tagList
end

get %r{/tag/detaal/([0-9]*)} do |id|
  @tag = @userTags.find(id)
  @words = @userWords.includes(:tags).where('tags.id' => id)
  erb :tagDetail
end

get %r{/tag/ediit/([0-9]*)} do |id|
  @tag = @userTags.find(id)
  erb :tagEdit
end

post '/api/new' do
  new_word = Word.create({:user_id => @userId, :wordtitle => params[:word], :memo => params[:memo]})
  if params['tag_id'].present? then
     params['tag_id'].each do |param|
       new_word.tags << @userTags.find(param)
     end
  end 
  redirect '/index'
	erb :index
end

post '/api/update' do
  wordid = params[:wordid]
  editword = @userWords.find(wordid)
  editword.update({:wordtitle => params[:word], :memo => params[:memo]})
  editword.tags.clear
  params['tag_id'].each do |param|
    editword.tags << @userTags.find(param)
  end
  redirect "/detail/#{wordid}"
  erb :detail 
end

post '/api/delete' do 
  @userWords.destroy(params['wordid'])
  redirect '/index'
	erb :index
end

post '/api/new/tag' do
  newTag = Tag.create({:user_id => @userId, :tagname => params[:tagname]})
  newTag.to_json(:root => false)
end

post '/api/tag/delete' do 
  @userTags.find(params['tagid']).destroy
  redirect '/tag/list'
  erb :tagList
end

post '/api/tag/update' do
  tagid = params[:tagid]
  edittag = @userTags.find(tagid)
  edittag.update({:tagname => params[:tagname]})
  redirect "/tag/detaal/#{tagid}"
  erb :tagDetail
end

