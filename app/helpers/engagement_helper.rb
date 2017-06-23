module EngagementHelper
  def academic?
    @engagement.academic_type == 'Academic'
  end
end
