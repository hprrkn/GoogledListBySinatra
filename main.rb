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
  @words = Word.all
	erb :index
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

post %r{/api/delete/([0-9]*)}do |id|
  Word.destroy(params['id'])
  redirect '/index'
	erb :index
end

