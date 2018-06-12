class ClientAccount < ApplicationRecord
  belongs_to :user
  has_many :student_accounts, dependent: :destroy
  has_many :engagements, dependent: :destroy
  has_many :invoices, through: :engagements
  has_many :client_reviews
  validates_presence_of :user
  validate :review_link_is_valid_url
  validates_presence_of :review_source, if: :review_link?
  validates_presence_of :review_link, if: :review_source?
  before_validation :set_text_fields_to_nil_if_empty

  ENGAGEMENT_TYPES = %w[online_academic in_person_academic
                        online_test_prep in_person_test_prep].freeze

  def academic_types_engaged
    ENGAGEMENT_TYPES.select do |type|
      user.rate_set?(type)
    end
  end

  def highest_rate_type
    return nil if academic_types_engaged.empty?
    academic_types_engaged.sort_by { |type| user.send(type + "_rate") }.last
  end

  def request_review?
    return false if client_reviews.any?
    invoices.count >= 2 && invoices.four_five_star.any?
  end

  def review_link_is_valid_url
    return if review_link =~ URI.regexp || review_link.nil?
    errors.add(:review_link, "must be a valid url")
  end

  def set_text_fields_to_nil_if_empty
    self.review_link = review_link.presence
    self.review_source = review_source.presence
  end
end
