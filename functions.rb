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

def is_valid?(pass)
  year_now = Time.now.year.to_i
  month_now = Time.now.month.to_i
  day_now = Time.now.day.to_i

  year_now.between?(pass['DateFrom'][0, 4].to_i, pass['DateTo'][0, 4].to_i)
  month_now.between?(pass['DateFrom'][5, 2].to_i, pass['DateTo'][5, 2].to_i)
  day_now >= pass['DateFrom'][8, 2].to_i || day_now <= pass['DateTo'][8, 2].to_i
end
