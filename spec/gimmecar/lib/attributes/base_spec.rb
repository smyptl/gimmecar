require "spec_helper"

describe Lib::Forms::Attributes::Base do

  it "#string" do
    a = Lib::Forms::Attributes::Base.new
    a.string('email')

    expect(a.fetch).to eq({ "email" => { "type"=>:string, "options"=>{} } })
  end
end
