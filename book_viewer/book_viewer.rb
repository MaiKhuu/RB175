require "tilt/erubis"
require "sinatra"
require "sinatra/reloader" if development?

helpers do
  def slugify(text)
    text.downcase.gsub(/[\s+]/, "-").gsub(/[^\w-]/,"")
  end

  # put each paragraphs into <p> tags
  # each <p> tag has an id denoting paragraph number
  def in_paragraphs(text)
    index = 0
    text.split("\n\n").map do |para|
      index += 1
      "<p id=paragraph#{index}>#{para}</p>"
    end.join
  end

  # this method iterates through each chapter
  # takes a block that will receive the chapter's number, title, and content
  def each_chapter
    @toc.each_with_index do |chapter_title, index|
      chapter_number = index + 1
      chapter_content = File.read("data/chp#{chapter_number}.txt")

      yield chapter_number, chapter_title, chapter_content
    end
  end

  def highlight(query, text)
    text.gsub(query, "<strong>#{query}</strong>")
  end

  # return an ARRAY of HASHES {chapter number, chapter title, matching paragraphs}
  # matching query case SENSITIVE
  def chapter_matching(query)
    return nil if query.nil? || query.empty?

    result = []
    matches = []
    each_chapter do |chapter_number, chapter_title, chapter_content|
      chapter_content.split("\n\n").each_with_index do |para, index|
        matches << {id: "paragraph#{index+1}", content: highlight(query, para)} if para.include?(query)
      end

      result << {number: chapter_number, title: chapter_title, paragraphs: matches} unless matches.empty?
      matches = []
    end

    result
  end

end

before do
  @title = "The Adventures of Sherlock Holmes"
  @toc = File.readlines("data/toc.txt")
end

not_found do
  redirect "/"
end

get "/" do
  erb :home
end

get "/chapters/:number" do
  @chapter_number = params[:number].to_i
  @chapter_content = File.read("data/chp#{@chapter_number}.txt")

  erb :chapter
end

get "/search" do
  @search_result = chapter_matching(params[:query])
  erb :search
end