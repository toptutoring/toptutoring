module InvoiceHelper
  def create_select_options_for_invoice
    group = @tutor_engagements.map { |engagement| engagement.student_id }.uniq
    group.map do |s_id|
      array_for_options(s_id)
    end
  end
  
  def array_for_options(id)
    student = User.find(id)
    [student.name, engagement_options(student)]
  end

  def engagement_options(student)
    student.student_engagements.map do |engagement|
      ["#{engagement.academic_type} for #{engagement.subject}", engagement.id]
    end
  end
end
