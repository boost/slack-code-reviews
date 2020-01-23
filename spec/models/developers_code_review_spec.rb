# frozen_string_literal: true

RSpec.describe DevelopersCodeReview, type: :model do
  describe 'associations' do
    it { should belong_to(:developer) }
    it { should belong_to(:code_review) }
  end
end
