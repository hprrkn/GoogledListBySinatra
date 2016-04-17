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
	erb :index
end


get '/detail/:id' do |id| 
  @word = Word.find(params['id'])
	erb :detail
end

post '/new' do
  Word.create({:word => params[:word], :memo => params[:memo]})
  redirect '/index'
	erb :index
end

get '/list' do
  @words = Word.all
	erb :list
end
