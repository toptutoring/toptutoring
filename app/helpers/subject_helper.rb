module SubjectHelper
  def type_options(subject)
    if subject.academic?
      type_buttons('Academic', 'Test Prep', 'primary', 'success', subject)
    elsif subject.test_prep?
      type_buttons('Test Prep', 'Academic', 'success', 'primary', subject)
    end
  end

  private

  def type_buttons(original, switch, og_class, sw_class, subject)
    tag.div(original, class: "btn btn-#{og_class}", disabled: true) +
      ' ' +
      link_to("Switch to #{switch}",
              admin_subject_path(subject,
                                 subject: { tutoring_type: switch }),
              class: "btn btn-outline btn-#{sw_class}", method: :patch)
  end
end
