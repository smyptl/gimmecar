class Services::Command::Driver < Lib::Services::Base

  attributes do |a|
    a.integer :id
  end

  output do
    object :driver, component: Services::Builders::Driver
  end


  private

  def query
    ::Driver.find(id)
  end
end
