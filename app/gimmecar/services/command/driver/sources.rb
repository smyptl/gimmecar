class Services::Command::Driver::Sources < Lib::Services::Base

  attributes do |a|
    a.integer :id
  end

  def output
    Driver.find(id).stripe_sources
  end
end
