module TutorHelper
  def tutor_balance(tutor)
    if current_user.admin
      tutor.balance
    else
      tutor.balance.to_f * 0.9
    end
  end
end
