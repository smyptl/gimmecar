module Lib::Forms::Actions
  extend ActiveSupport::Concern

  attr_reader :params

  included do
    define_callbacks :save, :execute

    def self.execute(success, failure, params = {})
      self.new().execute(success, failure, params)
    end

    def self.execute!(params = {})
      self.new().execute!(params)
    end
  end

  def execute(success, failure, params = {})
    @params = params

    run_callbacks :execute do
      if valid?
        ActiveRecord::Base.transaction(requires_new: true) do
          run_callbacks :save do
            save
          end
        end
        success.call(success_args)
      else
        failure.call(failure_args)
      end
    end
  end

  def execute!(params = {})
    success = lambda { |_| return true }
    failure = lambda { |_| return false }
    execute(success, failure, params)
  end

  private

  def save
    raise NotImplementedError
  end

  def success_args
    raise NotImplementedError
  end

  def failure_args
    {
      :errors => errors,
    }
  end

  def url_helper
    Rails.application.routes.url_helpers
  end
end
