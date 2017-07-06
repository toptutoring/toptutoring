module EngagementHelper

  def get_subject_name subject_id
    if is_numeric?(subject_id)
      Subject.find(subject_id).name
    else
      subject_id
    end
  end

  private

  def is_numeric?(val)
    true if Integer(val) rescue false
  end
end
