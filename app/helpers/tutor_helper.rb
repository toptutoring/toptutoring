module TutorHelper
  def tutor_balance(tutor)
    if current_user.admin
      tutor.balance
    elsif current_user.is_director?
      tutor.balance.to_f * 0.9
    end
  end
end
