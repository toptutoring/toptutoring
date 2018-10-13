class SwapClientService
  def initialize(user, engagement)
    @user = user
    @engagement = engagement
  end

  Result = Struct.new(:success?, :messages)

  def swap!
    return Result.new(true) unless @user.switch_to_student == "1"
    if originally_student_client?
      duplicate_student_client_into_client_with_student
    elsif originally_client_with_student?
      merge_client_with_student_into_student_client
    elsif originally_client_without_students_yet?
      convert_client_into_student_client
    end
  rescue ActiveRecord::RecordInvalid => e
    Result.new(false, "Swap failed to complete: #{e&.message}")
  end

  private

  def originally_student_client?
    @user.client_account.present? && @user.student_account.present?
  end

  def originally_client_with_student?
    @user.students.one?
  end

  def originally_client_without_students_yet?
    @user.students.empty? && @user.client_account.engagements.empty?
  end

  def duplicate_student_client_into_client_with_student
    ActiveRecord::Base.transaction do
      new_student_email = @user.email.split('@').join('+student@')
      new_student = User.create!(
        email: new_student_email,
        password: SecureRandom.hex(6),
        first_name: @user.first_name,
        phone_number: @user.phone_number
      )
      new_student_account = StudentAccount.create!(
        user: new_student,
        name: @user.student_account.name,
        client_account: @user.client_account
      )
      if @user.client_account.engagements.one?
        engagement = @user.client_account.engagements.last
        engagement.student_account = new_student_account
        engagement.save!
      elsif @user.client_account.engagements.many?
        raise ActiveRecord::RecordInvalid.new("Unable to duplicate student-client with multiple engagements")
      end
      @user.student_account.destroy!
      @user.students << new_student
      @user.save
      Result.new(true, "Successfully swapped client with student")
    end
  end

  def merge_client_with_student_into_student_client
    ActiveRecord::Base.transaction do
      old_student = @user.students.last
      @engagement.update_column(:student_account_id, nil) if @engagement.present?

      old_student.student_account.destroy!
      old_student.create_client_account!
      new_client = old_student
      new_client_account = new_client.client_account

      new_client.roles = [Role.find_by(name: "client")]
      new_client.save!

      @engagement.update_column(:client_account_id, nil) if @engagement.present?
      @user.client_account.destroy!
      new_client.client_account.student_accounts.create!(user: @user, name: @user.full_name)
      new_student = @user
      new_student_account = new_student.student_account
      new_student.roles = [Role.find_by(name: "student")]
      if @engagement.present?
        @engagement.client_account = new_client_account
        @engagement.student_account = new_student_account
        @engagement.save!
      elsif @user.client_account.engagements.many?
        raise ActiveRecord::RecordInvalid.new("Unable to merge client with multiple engagements")
      end

      Result.new(true, "Successfully swapped client with student")
    end
  end

  def convert_client_into_student_client
    @user.client_account.student_accounts.create!(user: @user, name: @user.full_name)
    Result.new(true, "Successfully made Client into a Student-client")
  end
end
