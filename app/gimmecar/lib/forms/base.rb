class Lib::Forms::Base < Lib::Attributes::Base

  attr_reader :params

  define_callbacks :save, :execute

  class << self
    def populate_form(data: nil, id: nil)
      new().populate_form(data: data, id: id)
    end

    def execute(success, failure, params = {})
      self.new().execute(success, failure, params)
    end

    def execute!(params = {})
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
    success = lambda { |_| true }
    failure = lambda { |_| false }
    execute(success, failure, params)
  end

  def populate_form(data: nil, id: nil)
    if id
      data = send(:data, id)
    end

    self._form_attributes.each { |key, _| send("#{key.to_s}=", data.send(key)) } if data
    self
  end

  private

  def data(id)
    raise Lib::Errors::NotImplemented
  end

  def save
    raise Lib::Errors::NotImplemented
  end

  def success_args
    raise Lib::Errors::NotImplemented
  end

  def failure_args
    {
      :errors => errors,
    }
  end
end
