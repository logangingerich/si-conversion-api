class SiController < ApplicationController
  def si
    input = params[:units]
    if input.present?
      new_unit = string_conversion(input)
      m_factor = calculate(input)
      render json: {unit_name: new_unit, multiplication_factor: m_factor}
    else
      render json: {Status: 404, Error: "Not a valid unit."}
    end
  end

  def string_conversion(string)
    new_string = string.split(%r{(\(|\)|\/|\*)})
    new_string.each do |str|
      case str
      when "minute"
        str.gsub!("minute", "s")
      when "hour"
        str.gsub!("hour", "s")
      when "degree"
        str.gsub!("degree", "rad")
      when "min"
        str.gsub!("min", "s")
      when "h"
        str.gsub!("h", "s")
      when "d"
        str.gsub!("d", "s")
      when "day"
        str.gsub!("day", "s")
      when "°"
        str.gsub!("°", "rad")
      when "‘"
        str.gsub!("‘", "rad")
      when "second"
        str.gsub!("second", "rad")
      when "“"
        str.gsub!("“", "rad")
      when "hectare"
        str.gsub!("hectare", "m^2")
      when "ha"
        str.gsub!("ha", "m^2")
      when "litre"
        str.gsub!("litre", "m^3")
      when "L"
        str.gsub!("L", "m^3")
      when "tonne"
        str.gsub!("tonne", "kg")
      when "t"
        str.gsub!("t", "kg")
      end
    end
    return new_string.join
  end

  def calculate(input)
    array = input.split(%r{(\(|\)|\/|\*)})
    array.each do |item|
      case item
      when "minute"
        item.gsub!("minute", "60.0")
      when "hour"
        item.gsub!("hour", "3600.0")
      when "degree"
        item.gsub!("degree", "#{(Math::PI / 180).to_f}")
      when "min"
        item.gsub!("min", "60.0")
      when "h"
        item.gsub!("h", "3600.0")
      when "d"
        item.gsub!("d", "86400.0")
      when "day"
        item.gsub!("day", "86400.0")
      when "°"
        item.gsub!("°", "#{(Math::PI / 180).to_f}")
      when "‘"
        item.gsub!("‘", "#{(Math::PI / 10800).to_f}")
      when "second"
        item.gsub!("second", "#{(Math::PI / 648000).to_f}")
      when "“"
        item.gsub!("“", "#{(Math::PI / 648000).to_f}")
      when "hectare"
        item.gsub!("hectare", "10000.0")
      when "ha"
        item.gsub!("ha", "10000.0")
      when "litre"
        item.gsub!("litre", "0.001")
      when "L"
        item.gsub!("L", "0.001")
      when "tonne"
        item.gsub!("tonne", "1000.0")
      when "t"
        item.gsub!("t", "1000.0")
      end
    end
    return eval(array.join).to_f.round(14)
  end
end
