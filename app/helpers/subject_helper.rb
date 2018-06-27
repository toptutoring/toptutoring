module SubjectHelper
  SUBJECT_TYPES = %w(test_preparation english foreign_language history math science other).freeze

  def type_options(subject)
    if subject.academic?
      type_buttons("Academic", "Test Prep", "primary", "success", subject)
    elsif subject.test_prep?
      type_buttons("Test Prep", "Academic", "success", "primary", subject)
    end
  end

  def subject_grouped_select_options
    SUBJECT_TYPES.each_with_object([]) do |k, obj|
      subjects = Subject.where(category: k)
      next if subjects.none?
      obj << [k.titlecase, subjects.map { |subject| [subject.name, subject.id] }]
    end
  end

  private

  def type_buttons(original, switch, og_class, sw_class, subject)
    tag.div(original, class: "btn btn-#{og_class}", disabled: true) +
      " " +
      link_to("Switch to #{switch}",
              admin_subject_path(subject,
                                 subject: { academic_type: switch }),
              class: "btn btn-outline btn-#{sw_class}", method: :patch)
  end
end
