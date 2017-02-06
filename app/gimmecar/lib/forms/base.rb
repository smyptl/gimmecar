class Lib::Forms::Base
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  PROHIBITED_METHODS = [
    :initialize,
  ]

  class_attribute :_form_attributes
  self._form_attributes = ActiveSupport::HashWithIndifferentAccess.new

  class << self
    # It passes the form attributes to its inherited class, checks if class created prohibited method
    def inherited(subclass)
      subclass._form_attributes = self._form_attributes.clone
      subclass.class_eval do
        def self.method_added(name)
          if self::PROHIBITED_METHODS.include?(name.to_sym)
            remove_method(name)
            raise Exception, "Can't override #{name} method."
          end
        end
      end
    end

    def populate_form(data: nil, id: nil)
      new().populate_form(data: data, id: id)
    end

    private

    # For each attribute in the form, it includes it in the _form_attributes
    # hash, which gets passed down to inherited classes (see inherited() above.!
    # It defines a getter and setter method for the attribute that read and write
    # to the @attributes instance variable
    def attributes
      attributes = Lib::Forms::Attributes::Base.new
      yield attributes
      _form_attributes.merge!(attributes.fetch)
      define_attribute_read_and_write_methods
    end

    def define_attribute_read_and_write_methods
      _form_attributes.each do |name, settings|
        define_attribute_read_method(name)
        define_method("#{name}=") { |value| write_attribute(name, value) }
      end
    end

    def define_attribute_read_method(name)
      define_method(name) { read_attribute(name) }
    end
  end

  def initialize(attrs = {})
    assign_attributes(attrs) unless attrs.blank?
  end

  def assign_attributes(attrs = {})
    attrs.each do |attr_name, value|
      self.public_send("#{attr_name}=", value)
    end
    self
  end

  def populate_form(data: nil, id: nil)
    if id
      data = send(:data, id)
    end

    self._form_attributes.each { |key, _| send("#{key.to_s}=", data.send(key)) } if data
    self
  end

  def attributes
    set_attributes
    modify_attributes
    get_attributes
  end

  def form_attributes
    get_attributes
  end

  private

  def data(id)
    raise NotImplementedError
  end

  # To add or remove the attributes define this method in the
  # inherited class and use write_attribute method to manipulate
  # attributes.
  def modify_attributes
  end

  def set_attributes
    @attributes ||= ActiveSupport::HashWithIndifferentAccess.new
  end
  alias_method :get_attributes, :set_attributes

  def read_attribute(attribute)
    get_attributes[attribute]
  end

  # It writes the attributes to the @attributes instance variable.
  #
  # If the _form_attributes contains the attribute it will typecast
  # to the appropriate type and options or else it will just equal the
  # value submitted.
  def write_attribute(attribute, value)
    attribute = attribute.to_sym
    if _form_attributes[attribute]
      get_attributes[attribute] = Lib::Forms::Attributes::Base.parse(value, _form_attributes[attribute])
    else
      # Returns value if no attribute specified by form
      get_attributes[attribute] = value
    end
  end
end
