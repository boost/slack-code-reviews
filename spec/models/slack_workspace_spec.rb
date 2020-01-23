# frozen_string_literal: true

RSpec.describe SlackWorkspace, type: :model do
  describe 'associations' do
    it { should have_many(:developers) }
    it { should have_many(:projects) }
    it { should have_many(:code_reviews) }
  end
end
