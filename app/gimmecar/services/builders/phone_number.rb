class Services::Builders::PhoneNumber < Lib::Services::Builder

  component do |c|
    c.attributes :phone_type,
      :number,
      :extension,
      :notes,
      :primary
  end
end
