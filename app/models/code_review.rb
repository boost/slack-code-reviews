class CodeReview < ApplicationRecord
  belongs_to :team

  belongs_to :reviewer1, class_name: 'Developer'
  belongs_to :reviewer2, class_name: 'Developer'
end
