class AddMultipleUrlsToCodeReviews < ActiveRecord::Migration[6.0]
  def up
    create_table :urls do |t|
      t.string :url, null: false

      t.belongs_to :code_review
    end

    default_url = 'https://github.com/boost/slack-code-reviews/pull/13'
    CodeReview.all.each do |cr|
      url = (cr.url.nil? ? default_url : cr.url)
      Url.create(url: url, code_review: cr)
    end

    remove_column(:code_reviews, :url, :string)
  end

  def down
    add_column(:code_reviews, :url, :string)

    CodeReview.each do |cr|
      cr.update(url: cr.urls.first)
    end

    drop_table :urls
  end
end
