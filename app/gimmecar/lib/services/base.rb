class Lib::Services::Base

  PROHIBITED_METHODS = [
    :include,
    :include_hash,
    :include?,
    :generated_on,
    :as_of,
    :date,
    :description,
    :api,
    :uri_helpers
  ]

  class << self
    def inherited(subclass)
      subclass.class_eval do
        def self.method_added(name)
          if self::PROHIBITED_METHODS.include?(name.to_sym)
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

  def with_permissions_for(id)
    @user_permission = UserPermission.data(id)
    self
  end

  def user_permission
    @user_permission || (raise NotImplementedError)
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
    @date = Lib::TypeCast::Date.type_cast(date)
    self
  end

  def date
    @date || (raise NotImplementedError)
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end
end
