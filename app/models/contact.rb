class Contact < ActiveRecord::Base

  after_save :load_into_soulmate

  def load_into_soulmate
    loader = Soulmate::Loader.new("contact")
    loader.add("term" => name, "id" => id)
  end

  def self.autocomplete_search(term)
    matches = Soulmate::Matcher.new('contact').matches_for_term(term)
    matches.collect {|match| {"id" => match["id"], "label" => match["term"], "value" => match["term"] } }
  end

  def self.regular_search(term)
    matches = Soulmate::Matcher.new('contact').matches_for_term(term)
    ids = matches.collect {|match| match["id"] }
    self.find(ids)
  end

end
