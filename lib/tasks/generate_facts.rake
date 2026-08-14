require "net/http"
require "json"
require "cgi"
require "nokogiri"

desc "Fill the database tables with fun facts"
task({ generate_facts: :environment }) do
  p "Creating fun facts"
  starting = Time.now

  if Rails.env.development?
    Card.destroy_all
    p "Database wiped"
  end

  uri = URI("https://opentdb.com/api.php?amount=50&type=multiple")
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)

  # Create cards
  data["results"].each do |card|
    Card.create!(
      category: Nokogiri::HTML.fragment(card["category"]).text,
      title: Nokogiri::HTML.fragment(card["correct_answer"]).text,
      fact: Nokogiri::HTML.fragment(card["question"]).text,
      incorrect_answers: card["incorrect_answers"].map do |answer|
        Nokogiri::HTML.fragment(answer).text
      end,
    )
  end
  p "Created #{Card.count} cards."
  p "#{starting}."
end
