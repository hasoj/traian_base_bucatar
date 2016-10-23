require 'koala'
require_relative './config/secrets.rb'
require_relative './lib/markov.rb'


markov = Markov.new

text = File.read('./sample_2')


markov.feed(text)
post = markov.generate_phrase(', ')
puts post

api = Koala::Facebook::API.new(FB_APP_TOKEN)
# api.put_wall_post(post)
 
