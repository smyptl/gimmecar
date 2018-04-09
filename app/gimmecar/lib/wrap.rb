module Lib::Wrap
  extend ActiveSupport::Concern

  included do
    def self.wrap(collection)
      collection.map { |c| self.new(c) }
    end
  end
end
