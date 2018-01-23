class Lib::Services::Base < Lib::Attributes::Base

  PROHIBITED_METHODS = [
    :include,
    :include_hash,
    :include?,
    :generated_on,
    :as_of,
    :date,
    :during_period,
    :period,
    :uri_helpers
  ]

  class << self
    def inherited(subclass)
      subclass.class_eval do
        def self.method_added(name)
          if Lib::Services::Base::PROHIBITED_METHODS.include?(name.to_sym)
            remove_method(name)
            raise Exception, "Can't override #{name} method."
          end
        end
      end
    end

    def fetch(*args)
      new(*args).fetch
    end

    def wrap(collection)
      collection.map { |c| fetch(c) }
    end
  end

  def fetch
    raise MethodNotImplemented
  end

  def user
    @user || (raise Lib::Errors::NotImplemented)
  end

  def include(hash)
    @include_hash = hash.with_indifferent_access
    self
  end

  def include_hash
    @include_hash || {}
  end

  def include?(key)
    Lib::TypeCast::Boolean.type_cast(include_hash[key]) || false
  end

  def generated_on
    @generated_on ||= DateTime.now
  end

  def as_of(date)
    @date = Lib::Attributes::TypeCast.date_time(date)
    self
  end

  def date
    @date || (raise Lib::Errors::NotImplemented)
  end

  def during_period(start_date, end_date)
    @period = Lib::DateRange.new(Lib::Attributes::TypeCast.date_time(start_date), Lib::Attributes::TypeCast.date_time(end_date))
    self
  end

  def period
    @period || (raise Lib::Errors::NotImplemented)
  end
end
