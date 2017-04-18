require 'spec_helper'

feature 'Create Invoice' do
  scenario 'has valid form' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.engagement.update(tutor_id: tutor.id)

    sign_in(tutor)

    expect(page).to have_content(student.name)
    expect(page).to have_content(student.engagement.subject)
  end

  scenario 'with invalid params' do
    tutor = FactoryGirl.create(:tutor_user)
    student = FactoryGirl.create(:student_user)
    student.engagement.update(tutor_id: tutor.id)

    sign_in(tutor)

    fill_in "invoice_hours", with: 0
    click_on "Submit"
    expect(page).to have_content('Hours must be greater than or equal to 0.5')
  end

  scenario 'with valid params' do
    tutor = FactoryGirl.create(:tutor_user)
    sufficient_balance_student = FactoryGirl.create(:student_user, :balance => 5)
    sufficient_balance_student.engagement.update(tutor_id: tutor.id, hourly_rate: 1)
    sufficient_balance_student.client.update(balance: 2)

    sign_in(tutor)
    
    fill_in "invoice_hours", with: 0.5
    click_on "Submit"

    expect(page).to have_content('Session successfully logged!')
  end

  scenario 'low balance warning' do 
    tutor   = FactoryGirl.create(:tutor_user)
    client  = FactoryGirl.create(:client_user, balance: 2)

    low_balance_student = FactoryGirl.create(:student_user, client_id: client.id)
    low_balance_student.engagement.update(tutor_id: tutor.id, hourly_rate: 1)

    sign_in(tutor)
    
    fill_in "invoice_hours", with: 1
    click_on "Submit"

    expect(page).to have_content('Session successfully logged!')
    expect(page).to have_no_content('The session has been logged but the client 
                    has a negative balance of hours. You may not be paid for this session 
                    unless the client adds to his/her hourly balance.')
                      
    visit dashboard_path 

    fill_in "invoice_hours", with: 2
    click_on "Submit"

    expect(page).to have_no_content('Session successfully logged!')
    expect(page).to have_content('The session has been logged but the client 
                    has a negative balance of hours. You may not be paid for this session 
                    unless the client adds to his/her hourly balance.')
    
  end
end