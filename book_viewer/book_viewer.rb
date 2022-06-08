require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt")
  @main_title = "The Adventures of Sherlock Holmes"
end

helpers do
  def slugify(text)
    text.downcase.gsub(/\s+/, "-").gsub(/^[\w-]/, "")
  end

  # returns raw content
  def content_of_chapter(number)
    File.read("data/chp#{number}.txt")
  end

  # returns <p id="chapter1-1"> <p>
  def in_paragraphs(text, pretext)
    index = 0
    text.split("\n\n").map do |paragraph|
      index += 1
      "<p id=\"#{pretext + "-" + index.to_s}\"> #{paragraph}</p>"
    end
  end

  # return ARRAY containing CHAPTER NUMBERS with matching query
  def chapters_matching(query)
    result = []
    (0..@contents.size-1).to_a.each do |index|
      result << (index + 1) if content_of_chapter(index+1).include?(query)
    end
    result
  end

  # returning ARRAY containing PARAGRAPH NUMBERS with matching query
  def paragraphs_matching(query, chapter_paragraphs)
    result = []
    chapter_paragraphs.each_with_index do |para, index|
      result << index  if para.include?(query)
    end
    result
  end

end

# not_found do
#   redirect "/"
# end

get "/" do
  erb :home
end

get "/chapters/:number" do
  @chapter_number = params[:number].to_i
  redirect "/" unless (1..@contents.size).to_a.include?(@chapter_number)

  @chapter_title = @contents[@chapter_number - 1]
  @chapter_content_in_paragraph =  in_paragraphs(content_of_chapter(params[:number]), "chapter" + @chapter_number.to_s)

  erb :chapter
end

get "/search" do
  erb :search
end