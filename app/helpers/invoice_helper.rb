module InvoiceHelper
  def create_select_options_for_invoice
    group = @tutor_engagements.map { |engagement| engagement.student_id }.uniq
    group.map do |s_id|
      array_for_options(s_id, current_user)
    end
  end
  
  def array_for_options(id, tutor)
    student = User.find(id)
    [student.name, engagement_options(student, tutor)]
  end

  def engagement_options(student, tutor)
    student.student_engagements.where(tutor_id: tutor.id).map do |engagement|
      ["#{engagement.academic_type} for #{engagement.subject}", engagement.id]
    end
  end
end
