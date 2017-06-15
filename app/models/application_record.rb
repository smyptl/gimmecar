class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  has_paper_trail

  def self.build_mock(*args, &block)
    r = new(*args, &block)
    r.readonly!
    r
  end
end
