class Lib::Actions::Base < Lib::Attributes::Base

  attr_reader :params

  define_callbacks :save, :execute

  class << self
    def execute(success, failure, **params)
      self.new().execute(success, failure, params)
    end

    def execute!(**params)
      self.new().execute!(params)
    end
  end

  def execute(success, failure, **params)
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

  def execute!(**params)
    success = lambda { |_| true }
    failure = lambda { |_| false }
    execute(success, failure, params)
  end

  private

  def data(id)
    raise NotImplementedError
  end

  def save
    raise NotImplementedError
  end

  def success_args
    raise NotImplementedError
  end

  def failure_args
    {
      errors: errors,
    }
  end
end
