# frozen_string_literal: true

RSpec.describe Slack::Action::AddCodeReview, type: :action do
  let!(:slack_workspace) { create(:slack_workspace) }
  let(:project)         { create(:project, slack_workspace: slack_workspace) }
  let(:requestor)       { create(:developer, project: project) }

  let(:url) { Faker::Internet.url host: 'github.com/boost' }

  subject :add_code_review do
    Slack::Action::AddCodeReview.new(
      slack_workspace,
      url,
      requestor,
      given_reviewers_tags
    )
  end

  describe 'giving reviewers' do
    context 'when no reviewer is given' do
      let(:given_reviewers_tags) { [] }

      it 'creates a code review with the given url' do
        expect do
          add_code_review
        end.to change { CodeReview.count }.by(1)

        expect(CodeReview.last.url).to eq(url)
      end

      context 'when there is someone else in the queue on the project' do
        let! :queue do
          [
            create(:developer),
            create(:developer, project: project),
            create(:developer, project: project)
          ]
        end

        it 'creates a code review' do
          expect do
            add_code_review
          end.to change { CodeReview.count }.by(1)
        end

        it 'picks the first developer on the project in the queue' do
          add_code_review
          expect(CodeReview.last.developers).to include(queue.second)
        end

        it 'picks the first developer on the queue' do
          add_code_review
          expect(CodeReview.last.developers).to include(queue.first)
        end
      end

      context 'when there is no one else in the queue on the project' do
        let! :queue do
          create_list(:developer, 3)
        end

        it 'picks the first two developers in the queue' do
          add_code_review
          expect(CodeReview.last.developers.to_a).to eq(queue.first(2))
        end
      end

      context 'when there is no one else in the queue' do
        let(:queue) { [] }

        it 'creates a code review' do
          expect do
            add_code_review
          end.to change { CodeReview.count }.by(1)
        end
      end
    end

    context 'when given one reviewer' do
      let!(:given_reviewer)      { create(:developer, name: '@gus') }
      let(:given_reviewers_tags) { ['<@123|gus>'] }

      it 'creates a code review with the given url' do
        expect do
          add_code_review
        end.to change { CodeReview.count }.by(1)

        expect(CodeReview.last.url).to eq(url)
      end

      it 'assigns the matching developer as a reviewer' do
        add_code_review
        expect(CodeReview.last.developers).to include(given_reviewer)
      end

      context 'when the given reviewer is on the requestors project' do
        before do
          given_reviewer.update(project: requestor.project)
        end

        context 'when there is someone else in the queue' do
          let! :queue do
            [
              *create_list(:developer, 2),
              create(:developer, project: project)
            ]
          end

          it 'creates a code review' do
            expect do
              add_code_review
            end.to change { CodeReview.count }.by(1)
          end

          it 'picks the next developer in the queue' do
            add_code_review
            expect(CodeReview.last.developers).to include(queue.first)
          end
        end

        context 'when there is no one else in the queue' do
          let(:queue) { [] }

          it 'creates a code review' do
            expect do
              add_code_review
            end.to change { CodeReview.count }.by(1)
          end
        end
      end

      context 'when the given reviewer is not on the requestors project' do
        context 'when there is someone else in the queue on the project' do
          let! :queue do
            [
              create(:developer),
              create(:developer, project: project),
              create(:developer, project: project)
            ]
          end

          it 'creates a code review' do
            expect do
              add_code_review
            end.to change { CodeReview.count }.by(1)
          end

          it 'picks the first developer on the project in the queue' do
            add_code_review
            expect(CodeReview.last.developers).to include(queue.second)
          end
        end

        context 'when there is no one else in the queue on the project' do
          let! :queue do
            create_list(:developer, 3)
          end

          it 'picks the first developer in the queue' do
            add_code_review
            expect(CodeReview.last.developers).to include(queue.first)
          end
        end

        context 'when there is no one else in the queue' do
          let(:queue) { [] }

          it 'creates a code review' do
            expect do
              add_code_review
            end.to change { CodeReview.count }.by(1)
          end
        end
      end
    end

    context 'when given two reviewers' do
      let!(:given_reviewers) do
        [create(:developer, name: '@gus'), create(:developer, name: '@paul')]
      end
      let(:given_reviewers_tags) { ['<@123|gus>', '<@321|paul>'] }

      it 'creates a code review with the given url' do
        expect do
          add_code_review
        end.to change { CodeReview.count }.by(1)

        expect(CodeReview.last.url).to eq(url)
      end

      it 'assigns both matching developers as the reviewers' do
        add_code_review
        expect(CodeReview.last.developers.to_a).to eq(given_reviewers)
      end
    end
  end
end
