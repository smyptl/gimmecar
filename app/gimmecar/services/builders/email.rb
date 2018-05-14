class Services::Builders::Email < Lib::Services::Builder

  component do |c|
    c.attributes :email_type,
      :email,
      :notes,
      :primary
  end
end
