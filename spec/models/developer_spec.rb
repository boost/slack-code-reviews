# frozen_string_literal: true

RSpec.describe Developer, type: :model do
  describe 'associations' do
    it { should belong_to(:slack_workspace) }
    it { should belong_to(:project).optional }
    it { should have_many(:developers_code_reviews) }
    it { should have_many(:code_reviews).through(:developers_code_reviews) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slack_id) }
  end
end
