module DashboardHelper
  def dwolla_message
    "Hello #{current_user.name}, your #{ current_user.has_role?("director") ? 'administrator' : 'director' }
      is using Dwolla in order to make transfers. Please click the button below to authenticate with Dwolla."
  end

  def get_academic_type_from_subject
    subject = current_user.client_info.subject

    if(subject.include?("ACT") || subject.include?("PSAT") || subject.include?("CASHSEE") || subject.include?("CHSPE") ||
      subject.include?("CLEP") || subject.include?("CPA") || subject.include?("EOC") || subject.include?("GED") || subject.include?("GMAT") ||
      subject.include?("GRE") || subject.include?("PCAT") || subject.include?("SAT") || subject.include?("TOEFL") || subject.include?("TOPS") ||
      subject.include?("WISC") || subject.include?("WPPSI"))

      "Test_Prep"
    else
      "Academic"
    end
  end
end
