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

  def engagement_rates_and_credits(engagement)
    client = engagement.client
    if engagement.academic?
      concat tag.p "Online: #{rate_credit_string(client, 'online_academic')}"
      concat tag.p "In-Person: #{rate_credit_string(client, 'in_person_academic')}"
    else
      concat tag.p "Online: #{rate_credit_string(client, 'online_test_prep')}"
      concat tag.p "In-Person: #{rate_credit_string(client, 'in_person_test_prep')}"
    end
  end

  def rate_credit_string(client, type)
    rate = client.send(type + "_rate")
    return "Not set" if rate == 0
    credit = client.send(type + "_credit")
    "$#{rate} / #{credit} hrs"
  end

  def engagement_client_credits(engagement)
    client = engagement.client
    if engagement.academic?
      concat tag.p "Online: #{client.online_academic_credit}" if engagement.rate_for?("online")
      concat tag.p "In-Person: #{client.in_person_academic_credit}" if engagement.rate_for?("in_person")
    else
      concat tag.p "Online: #{client.online_test_prep_credit}" if engagement.rate_for?("online")
      concat tag.p "In-Person: #{client.in_person_test_prep_credit}" if engagement.rate_for?("in_person")
    end
  end

  def actions_for_engagement(engagement, view)
    if engagement.archived?
      engagement_reactivate_link(engagement, view)
      engagement_delete_link(engagement) if engagement.able_to_delete?
    else
      engagement_edit_link(engagement)
      engagement_enable_link(engagement, view) if engagement.pending?
      engagement_delete_link(engagement) if engagement.able_to_delete?
      engagement_archive_link(engagement, view) if engagement.active?
    end
  end

  def engagement_edit_link(engagement)
    icon_link(edit_engagement_path(engagement), "ion-edit", "Edit this engagement",
              "edit_engagement_link_#{engagement.id}", classes: "mr-15")
  end

  def engagement_delete_link(engagement)
    render_icon_confirm_link("ion-trash-b", "Delete this engagement",
                             engagement_path(engagement), "delete_engagement_link_#{engagement.id}",
                             confirm_message: "This will permanently remove the engagement from the database. Are you sure?",
                             remote: true, link_method: :delete,
                             confirm_title: "Confirm removing engagement")
  end

  def engagement_enable_link(engagement, view)
    render_icon_confirm_link("ion-play", "Enable this engagement",
                             enable_engagement_path(engagement, view: view),
                             "enable_engagement_link_#{engagement.id}",
                             classes: "mr-15",
                             link_method: :patch,
                             remote: true,
                             confirm_message: "Are you sure you want to enable this engagement?",
                             confirm_title: "Confirm enabling engagement")
  end

  def engagement_reactivate_link(engagement, view)
    render_confirm_link("Reactivate",
                        enable_engagement_path(engagement, view: view),
                        "enable_engagement_link_#{engagement.id}",
                        classes: "btn",
                        link_method: :patch,
                        remote: true,
                        confirm_message: "Are you sure you want to enable this engagement?",
                        confirm_title: "Confirm enabling engagement")
  end

  def engagement_archive_link(engagement, view)
    render_icon_confirm_link("ion-android-archive", "Archive this engagement",
                             disable_engagement_path(engagement, view: view),
                             "archive_engagement_link_#{engagement.id}",
                             engagement_archive_alert_hash(engagement))
  end

  def engagement_archive_confirmation
    "Are you sure you want to archive this engagement? " \
      "Archiving will disable the tutor from viewing and invoicing this engagement."
  end

  def engagement_archive_alert_hash(engagement)
    result = { confirm_title: "Confirm archiving engagement",
               classes: "mr-15",
               link_method: :patch,
               remote: true,
               confirm_message: engagement_archive_confirmation }
    return result unless engagement.credits_remaining?
    result.tap { |result| result[:warning] = "Client currently has a positive credit balance" }
  end
end
