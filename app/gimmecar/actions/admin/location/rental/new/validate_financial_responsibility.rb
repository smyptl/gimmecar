class Actions::Admin::Location::Rental::New::ValidateFinancialResponsibility < Lib::Forms::Base
  include Actions::Admin::Location::Rental::New::Concerns::FinancialResponsibility

  def save
  end

  def success_args
  end
end
