class Item < ApplicationRecord
  # model associations
  belongs_to :checklist

  # validaton
  validates_presence_of :name
end
