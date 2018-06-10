class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  has_paper_trail

  def self.as(arg_1, arg_2, id:)
    unscope(:where).where(arel_table["#{arg_1}_id"].eq(id).or(arel_table["#{arg_2}_id"].eq(id)))
  end
end
