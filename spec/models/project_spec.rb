# frozen_string_literal: true

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should belong_to(:slack_workspace) }
    it { should have_many(:developers) }
  end

  describe 'natlib?' do
    it 'returns true when the project is natlib' do
      project = build(:project, name: 'natlib')

      expect(project.natlib?).to eq(true)
    end

    it 'returns false when the project is not natlib' do
      project = build(:project, name: 'superg')

      expect(project.natlib?).to eq(false)
    end
  end

  describe 'dnz?' do
    it 'returns true when the project is dnz' do
      project = build(:project, name: 'dnz')

      expect(project.dnz?).to eq(true)
    end

    it 'returns false when the project is not dnz' do
      project = build(:project, name: 'archives')

      expect(project.dnz?).to eq(false)
    end
  end
end
