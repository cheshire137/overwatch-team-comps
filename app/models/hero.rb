class Hero < ApplicationRecord
  validates :name, presence: true

  def image_name
    file_name = case name
    when 'D.Va' then 'dva'
    when 'Lúcio' then 'lucio'
    when 'Soldier: 76' then 'soldier76'
    when 'Torbjörn' then 'torbjorn'
    else name.downcase
    end
    "#{file_name}.png"
  end
end
