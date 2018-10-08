class SwapClientService
  def initialize(user, engagement)
    @user = user
    @engagement = engagement
  end

  Result = Struct.new(:success?, :messages)

  def swap!
    return Result.new(true) unless @user.switch_to_student == "1"
    if @user.students.one? && @user.client_account.engagements.one?
      make_client_into_student_and_swap
    elsif @user.students.empty? && @user.client_account.engagements.one?
      make_client_into_client_student_and_associate_existing_engagement
    elsif @user.students.empty? && @user.client_account.engagements.empty?
      make_student_account_for_user
    end
  rescue ActiveRecord::RecordInvalid => e
    Result.new(false, "Swap failed to complete: #{e.errors.full_messages}")
  end

  private

  def make_client_into_student_and_swap
    ActiveRecord::Base.transaction do
      old_student = @user.students.last
      @engagement.update_column(:student_account_id, nil)

      old_student.student_account.destroy!
      old_student.create_client_account!
      new_client = old_student
      new_client_account = new_client.client_account
      new_client.roles = [Role.find_by(name: "client")]
      new_client.save!

      @engagement.update_column(:client_account_id, nil)
      @user.client_account.destroy!
      new_client.client_account.student_accounts.create!(user: @user, name: @user.full_name)
      new_student = @user
      new_student_account = new_student.student_account
      new_student.roles = [Role.find_by(name: "student")]

      @engagement.client_account = new_client_account
      @engagement.student_account = new_student_account
      @engagement.save!
      Result.new(true, "Successfully swapped client with student")
    end
  end

  def make_client_into_client_student_and_associate_existing_engagement
    ActiveRecord::Base.transaction do
      engagement = @user.client_account.engagements.last
      # Make into client-student
      @user.client_account.student_accounts.create!(user: @user, name: @user.full_name)
      new_student_account = @user.student_account
      engagement.student_account = new_student_account
      engagement.save!
      Result.new(true, "Successfully made client into client-student")
    end
  end

  def make_student_account_for_user
    @user.client_account.student_accounts.create!(user: @user, name: @user.full_name)
    Result.new(true, "Successfully made student account for user")
  end
end
