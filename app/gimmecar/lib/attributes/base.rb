class Lib::Attributes::Base
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  PROHIBITED_METHODS = [
    :initialize,
    :assign_attributes,
    :attributes,
    :set_attributes,
    :get_attributes,
    :read_attribute,
    :write_attributes,
  ]

  class_attribute :_form_attributes
  self._form_attributes = ActiveSupport::HashWithIndifferentAccess.new

  class << self
    # It passes the form attributes to its inherited class, checks if class created prohibited method
    def inherited(subclass)
      clone_form_attributes(subclass)

      subclass.class_eval do
        def self.method_added(name)
          if Lib::Attributes::Base::PROHIBITED_METHODS.include?(name.to_sym)
            remove_method(name)
            raise Exception, "Can't override #{name} method."
          end
        end
      end
    end

    private

    def clone_form_attributes(klass)
      klass._form_attributes = self._form_attributes.clone
    end

    # For each attribute in the form, it includes it in the _form_attributes
    # hash, which gets passed down to inherited classes (see inherited() above.!
    # It defines a getter and setter method for the attribute that read and write
    # to the @attributes instance variable
    def attributes
      attributes = Lib::Attributes::Parser.new
      yield attributes
      _form_attributes.deep_merge!(attributes.retrieve)
      define_attribute_read_and_write_methods
    end

    def define_attribute_read_and_write_methods
      _form_attributes.each do |name, settings|
        define_attribute_read_and_write_method(name)

        if settings.fetch(:type) == :nested
          define_nested_attribute_read_methods(name, settings)
        end
      end
    end

    def define_attribute_read_and_write_method(name)
      define_attribute_read_method(name)
      define_method("#{name}=") { |value| write_attribute(name, value) }
    end

    def define_nested_attribute_read_methods(name, settings, nested = [])
      return if settings.dig(:options, :array)

      define_attribute_read_method(name, nested: nested)
      nested = nested + [name]

      settings.fetch(:attributes).each do |a_name, a_settings|
        if a_settings.fetch(:type) == :nested
          define_nested_attribute_read_methods(a_name, a_settings, nested)
        else
          define_attribute_read_method(a_name, nested: nested)
        end
      end
    end

    def define_attribute_read_method(name, nested: [])
      if nested.present?
        method_name = "#{nested.join('_')}_#{name}"
      else
        method_name = name
      end

      define_method(method_name) { read_attribute(name, nested: nested) }
    end
  end

  def initialize(attrs = {})
    assign_attributes(attrs) unless attrs.blank?
  end

  def assign_attributes(attrs = {})
    attrs.each do |attr_name, value|
      if _form_attributes.fetch(attr_name, false)
        self.public_send("#{attr_name}=", value)
      end
    end
    self
  end

  def attributes
    set_attributes
    modify_attributes
    get_attributes
  end

  private

  # To add or remove the attributes define this method in the
  # inherited class and use write_attribute method to manipulate
  # attributes.
  def modify_attributes
  end

  def set_attributes
    @attributes ||= ActiveSupport::HashWithIndifferentAccess.new
  end
  alias_method :get_attributes, :set_attributes

  def read_attribute(attribute, nested: [])
    get_attributes.dig(*nested, attribute)
  end

  # It writes the attributes to the @attributes instance variable.
  #
  # If the _form_attributes contains the attribute it will typecast
  # to the appropriate type and options or else it will just equal the
  # value submitted.
  def write_attribute(attribute, value)
    attribute = attribute.to_sym
    if _form_attributes[attribute]
      get_attributes[attribute] = Lib::Attributes::Parser.parse(value, _form_attributes[attribute])
    else
      # Returns value if no attribute specified by form
      get_attributes[attribute] = value
    end
  end
end
