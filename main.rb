require 'sinatra'
require 'active_record'
require "sinatra/reloader" if development?

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
  validates :username, presence: true
  validates :password, presence: true
end

class Word < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :users
  validates :wordtitle, presence: true
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :words
  belongs_to :users
  validates :tagname, presence: true
end

helpers do
  def validate(obj)
    if !obj.valid? then
      redirect request.referrer
      return
    end
  end 
end

before do
  if request.url =~ %r{/android} then
    #p request.cookies #cookies空っぽ
    if !params[:token].nil? && params[:token] == "tokenstring" && !params[:userId].nil? then
        @loginOk = true
        @userWords = User.find(params[:userId]).words
        @userTags = User.find(params[:userId]).tags
    else 
        @loginOk = false
    end
  elsif request.url =~ %r{/login} then
  else
     if !session[:loginOk] then
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
  if @user.present? && @user.password == params[:password]  then
    session[:loginOk] = true
    session[:uId] = @user.id
    redirect '/index'
    erb :index
  else
    redirect '/login'
    erb :login
  end
end

get '/logout' do
  session.clear
  redirect '/login'
  erb :login
end

get '/setting' do
  erb :setting
end

post '/login/register' do
  @user = User.create({:username => params[:username], :password => params[:password]})
  validate(@user)
  session[:loginOk] = true
  session[:uId] = @user.id
  redirect 'index'
  erb :index
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
  validate(new_word)
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
  editWord = @userWords.find(wordid)
  editWord.update({:wordtitle => params[:word], :memo => params[:memo]})
  validate(editWord)
  editWord.tags.clear
  params['tag_id'].each do |param|
    editWord.tags << @userTags.find(param)
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
  validate(newTag)
  newTag.to_json(:root => false)
end

post '/api/tag/delete' do 
  @userTags.find(params['tagid']).destroy
  redirect '/tag/list'
  erb :tagList
end

post '/api/tag/update' do
  tagid = params[:tagid]
  editTag = @userTags.find(tagid)
  editTag.update({:tagname => params[:tagname]})
  validate(editTag)
  redirect "/tag/detaal/#{tagid}"
  erb :tagDetail
end

post '/android/api/login' do
  @user = User.where({:username => params[:username]}).first
  if @user.present? && @user.password == params[:password]  then
    token = "tokenstring" # todo: token生成する どこでtoken保持する??
    res = {"status" => "200", "loginOk" => "true", "token" => token, "userId" => @user.id}
    res.to_json(:root => false)
  else
    res = {"status" => "200", "loginOk" => "false", "token" => "", "userId" => ""}
    res.to_json(:root => false)
  end
end

get '/android/api/index' do
    if @loginOk then
    p "loginok"
        result = {}
        comjson = []
        @userWords.group("strftime('%Y-%m', created_at)").count.each do |com|
            comjson << {"month" => com[0], "count" => com[1]}
        end
        tags = @userTags.all
        result["coms"] = comjson
        result["tagList"] = tags
        p result
        result.to_json(:root => false)
    end
end
