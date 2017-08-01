class ClientInfo < ActiveRecord::Base
  belongs_to :user
  validates_inclusion_of :student, :in => [true, false]

  def subject
    subject = self.read_attribute(:subject)
    if is_numeric?(subject)
      Subject.find(subject).name
    else
      subject
    end
  end

  def is_numeric?(val)
    true if Integer(val) rescue false
  end
end
