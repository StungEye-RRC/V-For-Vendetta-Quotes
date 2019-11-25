# frozen_string_literal: true

120.times do
  Quote.create(content: Faker::Movies::VForVendetta.unique.quote)
end
