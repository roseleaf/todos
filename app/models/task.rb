class Task < ActiveRecord::Base
  attr_accessible :is_completed, :list_id, :text
  belongs_to :list
end


