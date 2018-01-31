class Lib::Services::Base < Lib::Attributes::Base

  PROHIBITED_METHODS = [
    :include,
    :include_hash,
    :include?,
  ]

  attr_reader :params

  class_attribute :_output
  self._output = nil

  class << self
    def inherited(subclass)
      subclass._output = self._output

      subclass.class_eval do
        def self.method_added(name)
          if Lib::Services::Base::PROHIBITED_METHODS.include?(name.to_sym)
            remove_method(name)
            raise Exception, "Can't override #{name} method."
          end
        end
      end
    end

    def fetch(success, failure, params = {})
      self.new().fetch(success, failure, params)
    end

    def fetch!(params = {})
      self.new().fetch!(params)
    end

    def output(&block)
      generator = Lib::Services::Generator.new
      self._output = generator.instance_exec(&block).fetch
    end
  end

  def fetch(success, failure, params = {})
    @params = params

    run_callbacks :fetch do
      if valid?
        success.call(output)
      else
        failure.call(failure_args)
      end
    end
  end

  def fetch!(params = {})
    success = lambda { |args| args }
    failure = lambda { |_| false }
    fetch(success, failure, params)
  end

  def output
    _output
  end

  private

  def query
    raise Lib::Errors::NotImplemented
  end

  def include(hash)
    include_hash = hash.with_indifferent_access
    self
  end

  def include_hash
    @include_hash || {}
  end

  def include?(key)
    Lib::Attributes::TypeCast.boolean(include_hash[key]) || false
  end

  def failure_args
    {
      :errors => errors,
    }
  end
end
