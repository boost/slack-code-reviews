# frozen_string_literal: true

RSpec.describe SlackWorkspace, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:developers) }
    it { is_expected.to have_many(:projects) }
    it { is_expected.to have_many(:code_reviews) }
  end
end
