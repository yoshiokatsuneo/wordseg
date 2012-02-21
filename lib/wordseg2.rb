#!/usr/bin/ruby


class Dictword
	attr_reader	:word
	attr_reader	:val
	def initialize(word, val)
		@word = word
		@val = val
	end
end

class Wordseg2
  def initialize
    dictfile = File.dirname(__FILE__) + "/finnish.utf8.dict"
    dictbody = File.read(dictfile, encoding:'UTF-8');
    lines = dictbody.split(/\r?\n/);
    lines.map! { |item|
    	item.sub(/\/.*/, '')
    }

    @dict = Hash.new
    lines.each { |line|
    	key = get_simple_style_word(line)
    	val = line.length * line.length
    	# print "key=[#{key}]\n"
    	@dict[key] = Dictword.new(line, val)
    }

  end

  def get_simple_style_word(str)
  	str2 = str.dup
  #	a_dot_dot = "\xc3\xa4" # UTF-8
    a_dot_dot = "\u00E4" # Unicode
  #	o_dot_dot = "\xc3\xb6" # UTF-8
  	o_dot_dot = "\u00F6" # Unicode 

  	str2.gsub!(/#{a_dot_dot}/, 'a')
  	str2.gsub!(/#{o_dot_dot}/, 'o')
  	str2.tr!("A-Z", "a-z")
  	return str2
  end


  def val_word(word)
  	word2 = get_simple_style_word(word)
  	if(@dict[word2])
  		return @dict[word2]
  	else
  		return Dictword.new(word, 0)
  	end
  end

  def split_word(line)
  	max_str = Array.new
  	max_value = Array.new

  	max_str[0] = Array.new;
  	max_value[0] = 0
  	(1..line.length).each{ |i|
  		max_str[i] = Array.new;
  		max_value[i] = 0
  		(0..i-1).each{ |j|
  			dictword = val_word(line[j, i-j])
  			str = max_str[j] + [ dictword.word ]
  			val = max_value[j] + dictword.val;
  			if (val >= max_value[i])
  				max_str[i] = str;
  				max_value[i] = val;
  			end
  		}
  	}
  	return max_str[line.length];
  end

  def words_to_str(words)
    str = ""
    words.each { |word|
      str = str + word + " ";
    }
    return str
  end
end

if $0 == __FILE__
  wordseg = Wordseg.new
  while line = $stdin.gets
  	line.chomp!
  	words = wordseg.split_word(line)
  	print wordseg.words_to_str(words), "\n";
  end
end
