class Actions::Admin::Location::Rental::New::ValidateTermsAndConditions < Lib::Actions::Base
  include Actions::Admin::Location::Rental::New::Concerns::TermsAndConditions

  def save
  end

  def success_args
  end
end
