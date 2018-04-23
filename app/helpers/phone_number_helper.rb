module PhoneNumberHelper
  def phone_number_display(number_object, styles: nil, link: true)
    phone_number = convert_to_phone_number(number_object)
    return if phone_number.invalid?
    link ? link_to_phone_number(phone_number, styles) : phone_number.national
  end

  def convert_to_phone_number(number_object)
    return Phonelib.parse(number_object) if number_object.class == String
    Phonelib.parse(number_object.phone_number,
                   number_object.country_code)
  end

  def link_to_phone_number(phone_number, styles)
    tag.a href: "tel:#{phone_number.international.tr(' -', '')}", class: styles do
      phone_number.national
    end
  end
end
