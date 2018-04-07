class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  has_paper_trail

  def self.as(arg_1, arg_2, id:)
    unscope(:where).where("#{arg_1}_id = :id OR #{arg_2}_id = :id", id: id)
  end
end
