class Subject < ActiveRecord::Base
  validates_uniqueness_of :name

  TEST_PREP_SUBJECTS = %w(ACT PSAT CASHEE CHSPE
                          CLEP CPA EOC GED GMAT
                          GRE PCAT SAT TOEFL TOPS
                          WISC WPPSI).freeze

  belongs_to :user

  def test_prep?
    (TEST_PREP_SUBJECTS.map { |subject| name.include?(subject) }).include?(true)
  end
end
