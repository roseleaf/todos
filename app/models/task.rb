class Task < ActiveRecord::Base
  attr_accessible :is_completed, :list_id, :text
  belongs_to :list, counter_cache: true
  validates :text, presence: true
end


