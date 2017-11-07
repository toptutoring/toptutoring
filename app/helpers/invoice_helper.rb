module InvoiceHelper
  def pay_all_link(invoices, type)
    return unless authorized_to_pay?(invoices, type)
    total = if type == 'timesheets' then Invoice.contractor_pending_total
            else Invoice.tutor_pending_total
            end
    render 'admin/invoices/pay_all_link', type: type, total_for_all: total
  end

  def delete_link(invoice)
    if invoice.status == 'pending'
      link_to "Delete", delete_path(invoice), method: :delete, class: "btn btn-sm btn-outline btn-danger"
    else
      "No actions available"
    end
  end

  private

  def authorized_to_pay?(invoices, type)
    return false if invoices.empty?
    return true if current_user.has_role?('admin')
    type == 'invoices' && current_user.has_role?('director')
  end

  def delete_path(invoice)
    return timesheet_path(invoice) if invoice.submitter_type == "by_contractor"
    tutors_invoice_path(invoice)
  end
end
