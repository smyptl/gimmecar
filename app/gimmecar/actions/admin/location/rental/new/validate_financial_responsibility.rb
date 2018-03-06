class Actions::Admin::Location::Rental::New::ValidateFinancialResponsibility < Lib::Actions::Base
  include Actions::Admin::Location::Rental::New::Concerns::FinancialResponsibility

  def save
  end

  def success_args
  end
end
