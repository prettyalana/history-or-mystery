require "net/http"
require "json"
require "cgi"

desc "Fill the database tables with fun facts"
task({ generate_facts: :environment }) do
  p "Creating fun facts"
  starting = Time.now

  uri = URI("https://opentdb.com/api.php?amount=50")
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)

  # Create cards
  data["results"].each do |card|
    Card.create!(
      category: CGI.unescapeHTML(card["category"]),
      title: CGI.unescapeHTML(card["correct_answer"]),
      fact: CGI.unescapeHTML(card["question"]),
    )
  end

  p "Created #{Card.count} cards."
  p "#{starting}."
end
