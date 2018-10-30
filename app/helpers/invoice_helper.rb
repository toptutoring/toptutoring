module InvoiceHelper
  def pay_all_link(invoices, type)
    # Disable mass pay in favor of migrating to Stripe single pay
    unless Flipper.enabled?(:stripe_payouts)
      return unless authorized_to_pay?(invoices, type)
      total = if type == 'timesheets' then Invoice.contractor_pending_total
              else Invoice.tutor_pending_total
              end
      render 'admin/invoices/pay_all_link', type: type, total_for_all: total
    end
  end

  def delete_link(invoice)
    if invoice.status == 'pending'
      link_to "Delete", delete_path(invoice), method: :delete, class: "btn btn-sm btn-outline btn-danger"
    else
      "No actions available"
    end
  end

  def invoice_note_label(invoice)
    return unless invoice.note
    content_tag(:p, class: "label label-outline label-danger") do
      invoice.note
    end
  end

  def invoice_actions(invoice)
    payment_text = if invoice.submitter.stripe_uid && Flipper.enabled?(:stripe_payouts)
                     "Pay"
                   else
                     "Pay with Dwolla"
                  end
    return "No actions available" unless invoice.status == 'pending'
    link_to("Edit", edit_admin_invoice_path(invoice),
            class: "btn btn-sm btn-outline btn-primary") +
      link_to(payment_text, admin_payments_path({ invoice: invoice }),
              method: :post, data: { disable_with: 'Submitting' },
              class: "btn btn-sm btn-outline btn-primary") +
      link_to("Deny", deny_admin_invoice_path(invoice),
              data: { disable_with: 'Updating' },
              method: :patch, class: "btn btn-sm btn-outline btn-danger")
  end

  private

  def authorized_to_pay?(invoices, type)
    return false if invoices.empty?
    return true if current_user.admin?
    type == 'invoices' && current_user.has_role?('director')
  end

  def delete_path(invoice)
    return timesheet_path(invoice) if invoice.submitter_type == "by_contractor"
    tutors_invoice_path(invoice)
  end
end
