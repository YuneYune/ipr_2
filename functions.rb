# frozen_string_literal: true

require 'securerandom'

def generate_id
  hex = SecureRandom.hex.upcase
  indexes = [8, 13, 18, 23]
  indexes.each do |index|
    hex.insert(index, '-')
  end
  hex
end
