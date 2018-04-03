class Services::Command::Location::Revenue < Lib::Services::Base

  attributes do |a|
    a.string :slug
  end

  private

  def output
    query
  end

  def query
    Location.includes(:rental_rates).find_by(slug: slug).rental_rates.group_by_month(:date, format: '%b %Y').sum(:sub_total)
  end
end
