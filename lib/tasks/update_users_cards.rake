namespace :update do
  task users_cards: :environment do
    # Update users cards
    User.with_client_role.each do |user|
      CreditCard.create(
        customer_id: user.customer_id,
        confirmed: true,
        primary: true,
        user_id: user.id
      );
    end
  end
end
