class Services::Admin::Location::Drivers::Search < Lib::Services::Base

  attributes do |a|
    a.date :date_of_birth
    a.string :name_first
    a.string :name_last
  end

  validates :date_of_birth, :name,
    presence: true

  output do
    object :driver, component: Services::Builders::Driver
  end

  private

  def query
    FuzzyMatch.new(Driver.where(date_of_birth: date_range), read: :name).find(name)
  end

  def name
    "#{name_first} #{name_last}"
  end

  def date_range
    (date_of_birth - 15.days)..(date_of_birth + 15.days)
  end
end
