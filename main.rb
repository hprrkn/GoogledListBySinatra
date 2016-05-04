require 'sinatra'
require 'active_record'
require 'logger'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./googledword.db"
)

class Word < ActiveRecord::Base
  has_and_belongs_to_many :tags
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :words
end

get '/index' do
  @countOfMonth = Word.group("strftime('%Y-%m', created_at)").count.each
  @tags = Tag.all
  p Tag.all
	erb :index
end

get %r{/list/(\d{4})\-(\d{2})} do |y,m|
  from = Date::new(y.to_i,m.to_i,1)
  to = from >> 1
  @words = Word.where("created_at >= ? AND created_at < ?", from.strftime("%Y-%m-%d"), to.strftime("%Y-%m-%d"))
  erb :list
end  

get %r{/detail/([0-9]*)} do |id| 
  @word = Word.find(id)
	erb :detail
end

get %r{/edit/([0-9]*)} do |id|
  @word = Word.find(id)
  @tags = Tag.all
  erb :edit
end

get '/tag/list' do
  @tags = Tag.all
  erb :tagList
end

get %r{/tag/detaal/([0-9]*)} do |id|
  @tag = Tag.find(id)
  @words = Word.includes(:tags).where('tags.id' => id)
  erb :tagDetail
end

get %r{/tag/ediit/([0-9]*)} do |id|
  @tag = Tag.find(id)
  erb :tagEdit
end

post '/api/new' do
  new_word = Word.create({:wordtitle => params[:word], :memo => params[:memo]})
  params['tag_id'].each do |param|
    new_word.tags << Tag.find(param)
  end 
  redirect '/index'
	erb :index
end

post '/api/update' do
  wordid = params[:wordid]
  editword = Word.find(wordid)
  editword.update({:wordtitle => params[:word], :memo => params[:memo]})
  editword.tags.clear
  params['tag_id'].each do |param|
    editword.tags << Tag.find(param)
  end
  redirect "/detail/#{wordid}"
  erb :detail 
end

post '/api/delete' do 
  Word.destroy(params['wordid'])
  redirect '/index'
	erb :index
end

post '/api/new/tag' do
  newTag = Tag.create({:tagname => params[:tagname]})
  newTag.to_json(:root => false)
end

post '/api/tag/delete' do 
  Tag.find(params['tagid']).destroy
  redirect '/tag/list'
  erb :tagList
end

post '/api/tag/update' do
  tagid = params[:tagid]
  edittag = Tag.find(tagid)
  edittag.update({:tagname => params[:tagname]})
  redirect "/tag/detaal/#{tagid}"
  erb :tagDetail
end

