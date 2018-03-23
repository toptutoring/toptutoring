module EngagementHelper
  def subject_info(engagement)
    return tag.p "Other" if engagement.subject_id == 1
    tag.p engagement.subject.name
  end

  def engagement_state_label(engagement)
    icon_type = case engagement.state
                when "active" then "play text-success"
                when "pending" then "clock text-default"
                else "stop text-danger"
                end
    tag.icon class: "mr-10 icon ion-#{icon_type}"
  end

  def rates_and_credits(engagement)
    client = engagement.client
    if engagement.academic?
      concat tag.p "Online: #{rate_credit_string(client, "online_academic")}" if engagement.rate_for?("online")
      concat tag.p "In-Person: #{rate_credit_string(client, "in_person_academic")}" if engagement.rate_for?("in_person")
    else
      concat tag.p "Online: #{rate_credit_string(client, "online_test_prep")}" if engagement.rate_for?("online")
      concat tag.p "In-Person: #{rate_credit_string(client, "in_person_test_prep")}" if engagement.rate_for?("in_person")
    end
  end


  def rate_credit_string(client, type)
    rate = client.send(type + "_rate")
    credit = client.send(type + "_credit")
    "$#{rate} / #{credit} hrs"
  end

  def client_credits(engagement)
    client = engagement.client
    if engagement.academic?
      concat tag.p "Online: #{client.online_academic_credit}" if engagement.rate_for?("online")
      concat tag.p "In-Person: #{client.in_person_academic_credit}" if engagement.rate_for?("in_person")
    else
      concat tag.p "Online: #{client.online_test_prep_credit}" if engagement.rate_for?("online")
      concat tag.p "In-Person: #{client.in_person_test_prep_credit}" if engagement.rate_for?("in_person")
    end
  end

  def actions_for_engagement(engagement)
    concat edit_link(engagement)    
    concat misc_action_link(engagement)
  end

  def edit_link(engagement)
    link_to edit_engagement_path(engagement), data: { toggle: "tooltip", placement: "top", "original-title" => "Edit this engagement" }, class: "mr-15 fs-24" do 
      tag.i class: "icon ion-edit"
    end 
  end

  def misc_action_link(engagement)
    if engagement.tutor_account && engagement.pending? 
       link_to enable_engagement_path(engagement), data: { toggle: "tooltip", placement: "top", "original-title" => "Enable this engagement", confirm: "Enable this engagement?" }, class: "fs-24" do 
        tag.i class: "icon ion-play"
      end 
    elsif engagement.active? 
      link_to disable_engagement_path(engagement), data: { toggle: "tooltip", placement: "top", "original-title" => "Archive this engagement", confirm: "Archive this engagement? Archiving will disable the tutor from viewing and invoicing this engagement." }, class: "fs-24" do 
        tag.i class: "icon ion-android-archive"
      end 
    elsif engagement.invoices.empty?
      link_to engagement_path(engagement), remote: true, method: :delete, data: { toggle: "tooltip", placement: "top", "original-title" => "Delete this engagement", confirm: "This will permanently remove the engagement from the databse. Are you sure?" }, class: "fs-24" do 
        tag.i class: "icon ion-trash-b"
      end 
    end 
  end
end
