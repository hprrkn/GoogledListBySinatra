require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./googledword.db"
)

class Word < ActiveRecord::Base
  has_many :tag
end

class Tag < ActiveRecord::Base
  belongs_to :word
end

get '/index' do
  @countOfMonth = Word.group("strftime('%Y-%m', created_at)").count.each
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

post '/api/new' do
  Word.create({:word => params[:word], :memo => params[:memo]})
  redirect '/index'
	erb :index
end

post '/api/delete' do |id|
  Word.destroy(params['id'])
  redirect '/index'
	erb :index
end

