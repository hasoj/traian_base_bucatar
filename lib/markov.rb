class Markov
	TOKEN_SPLITTER    = %r{\s+|(\,\s+)|(\.\s+|\.$)|(\?\s+|\?$)|(\!\s+|\!$)}.freeze
	SENTENCE_END      = %r{\A[\.|\?|!]\z}.freeze
	attr_accessor :state
	require 'json'
	def initialize
		@state = {}
	end


	def  feed(text)
		tokens = text.split(TOKEN_SPLITTER)
		# puts tokens.to_json
		push(tokens)
		# puts @state.to_json

	end

	def generate_phrase(token)
		#token is a string de forma"Hello"
		#strip elimina whitespaceuri
		token = token.strip
		key = [token]
		return '' unless @state[key]  #unless inversul lui if
		buffer = [token]

		loop do 
			break if key[0] =~ SENTENCE_END # =~ MATCH PE EXPRESII REGULATE	
			value      = @state[key]
			random_number = rand()
			next_token = value
				.select do |word, data|
					data[:lower] < random_number && data[:upper] >= random_number
				end
					.to_a[0][0]
			# next_token = value.to_a.sample[0]
			buffer.push(next_token)
			key        = [next_token]
		end	
		buffer.join(' ')
	end

	def normalize!
		@state.each do |key, word_hash|
			result = word_hash
				.reduce(0) do |total, word_pair|
				#word pair e array contine next word si occurances
				total + word_pair[1][:occurance]
			end
				.to_f

			word_hash.each do |word, data|
				data[:probability] = data[:occurance].to_f/ result
			end
			word_hash.reduce(0.0) do |total, word_pair|
				data = word_pair[1]

				data[:lower] = total
				data[:upper] = total + data[:probability]
			end
		end
		

	end

	private
	def push(tokens)
		index = 0
		while index < tokens.size - 1
			current_token = tokens[index].strip
			next_token = tokens[index+1].strip
			#['cuvant'] => {'urmatorul' => 2,'altul' => 3}
			key = [current_token]

			if existing = @state[key]
			#['cuvant'] => {'urmatorul' => 2,'altul' => 3}
			    count = existing[next_token] || {occurance: 0}
				existing[next_token] ={occurance: count[:occurance] + 1}
			else
				@state[key] = {next_token => {occurance: 1}}
			end
			index += 1
		end
		
	end
end	