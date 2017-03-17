class Hero < ApplicationRecord
  validates :name, presence: true

  def slug
    case name
    when 'D.Va' then 'dva'
    when 'Lúcio' then 'lucio'
    when 'Soldier: 76' then 'soldier76'
    when 'Torbjörn' then 'torbjorn'
    else name.downcase
    end
  end

  def image_name
    "#{slug}.png"
  end
end
