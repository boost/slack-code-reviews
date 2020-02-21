# frozen_string_literal: true

# A url for a code review
class Url < ApplicationRecord
  belongs_to :code_review

  validate :valid_url?, :merge_request?

  before_save :sanitize_url

  SLACK_URL_REG = /^<(.*)\|.*>$/.freeze

  # eg: boost/slack-code-reviews/pulls/14
  GITHUB_FORMAT_REGEX = %r{^/(.*)/(.*)/pulls/(\d+)}.freeze
  # eg: digitalnz/shared-repository/merge_requests/23
  GITLAB_FORMAT_REGEX = %r{^/(.*)/(.*)/merge_requests/(\d+)}.freeze

  PATH_REGEX = %r{^/(.*)/(.*)/.*/(\d+)}.freeze

  def sanitize_url
    # if the url comes from slack
    self.url = url.scan(SLACK_URL_REG).flatten.first if url.match(SLACK_URL_REG)
    u = uri
    u.path = "/#{organisation}/#{project}/#{path_keyword}/#{request_id}"

    self.url = u.to_s
  end

  def valid_url?
    u = uri
    return if u.is_a?(URI::HTTP) && !u.host.nil? && !u.path.nil?

    errors.add(:url, 'is not a valid URL.')
  end

  def merge_request?
    return if gitlab_format? || github_format?

    errors.add(:url, 'is not a valid pull request format.')
  end

  def gitlab_format?
    uri.path.match?(GITLAB_FORMAT_REGEX)
  end

  def github_format?
    uri.path.match?(GITHUB_FORMAT_REGEX)
  end

  def organisation
    uri.path.scan(PATH_REGEX).flatten.first
  end

  def project
    uri.path.scan(PATH_REGEX).flatten.second
  end

  def request_id
    uri.path.scan(PATH_REGEX).flatten.last
  end

  def path_keyword
    return 'pulls' if github_format?
    return 'merge_requests' if gitlab_format?
  end

  def slack_url
    "<#{url}|#{uri.path}>"
  end

  def path
    uri.path
  end

  def uri
    URI(url)
  end
end
