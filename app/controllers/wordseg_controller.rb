require 'wordseg2'

class WordsegController < ApplicationController
  @@wordseg = nil
  def show
    if(! @@wordseg )
      @@wordseg = Wordseg2.new
    end
    str = "yritystietoturvaratkaisujen"
    if(params && params[:searchstr])
      str = params[:searchstr]
    end
    words = @@wordseg.split_word(str)
    @analyze_result = @@wordseg.words_to_str(words)
    @searchstr = str
  end
end
