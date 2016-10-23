require          'koala'
require_relative './config/secrets.rb'
require_relative './lib/markov.rb'



markov = Markov.new

if File.exists?('./tmp/state')
	dump   = File.read('./tmp/state')
	markov = Marshal.load(dump)
else

	text = File.read('./sample_1')
	markov.feed(text)
	markov.normalize!

end

post = markov.generate_phrase(', ')
api = Koala::Facebook::API.new(FB_APP_TOKEN)
api.put_wall_post(post)
 
unless File.exists?('./tmp/state')
	File.open('./tmp/state', 'w') do |file|
		Marshal.dump(markov, file)
		end	
end
	