class Lib::Forms::Base
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include Lib::Forms::NestedAttributes
  #include Lib::Forms::Documents
  #include Lib::Forms::Signatures

  PROHIBITED_METHODS = [
    :initialize,
    :assign_attributes,
    :populate_form,
    :get_attributes,
    :set_attributes,
    :form_attributes,
    :read_attribute,
    :write_attribute,
    :parse_attribute,
    :write_document,
    :attributes_with_documents_extracted,
    :parse_document,
    :parse_document_for_audit_log,
    :save_documents,
    :upload_single_document,
    :upload_array_of_documents,
    :upload_document,
    :old_document,
    :metadata,
    :write_signature,
    :parse_signature,
    :parse_signature_for_audit_log,
    :save_signatures,
    :save_signature
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

    def populate_form(data_or_id)
      new().populate_form(data_or_id)
    end

    private

    # For each attribute in the form, it includes it in the _form_attributes
    # hash, which gets passed down to inherited classes (see inherited() above.!
    # It defines a getter and setter method for the attribute that read and write
    # to the @attributes instance variable
    def attribute(name, type, options = {}, &block)
      _form_attributes[name] = {:type => type, :options => options}
      define_attribute_read_and_write_methods(name)
    end

    def define_attribute_read_and_write_methods(name)
      define_attribute_read_method(name)
      define_method("#{name}=") { |value| write_attribute(name, value) }
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

  def populate_form(data_or_id)
    if data_or_id.respond_to?(:to_i)
      data = send(:data, data_or_id)
    else
      data = data_or_id
    end
    self._form_attributes.each { |key, _| send("#{key.to_s}=", data.send(key)) } if data
    self
  end

  def attributes
    set_attributes
    modify_attributes
    get_attributes
  end

  # This method will not call modify_attributes, designed to avoid
  # data manipulations to ensure data can be used for javascript
  # forms.
  # Sends a hash of attributes with the structure
  # of data expected, even if the form has npt
  # been populated yet
  def form_attributes
    return get_attributes unless @attributes.nil?
    attrs = {}
    self._form_attributes.each do |key, value|
      attr_value = nil
      case value[:type]
      when :document, :signature
        if value[:options][:array]
          attr_value = []
        else
          attr_value = { }
        end
      when :nested
        attr_value = [value[:attributes].reduce({}) { |hash, (k, _)|  hash.merge(k.to_sym => nil)}]
      else
        attr_value = nil
      end

      attrs[key] = attr_value
    end
    attrs
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

  def get_attributes
    @attributes ||= ActiveSupport::HashWithIndifferentAccess.new
  end
  alias_method :set_attributes, :get_attributes

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
      # Retrieves the options and type of the attribute
      type    = _form_attributes[attribute][:type]
      options = _form_attributes[attribute][:options]

      get_attributes[attribute] = parse_attribute(value, type, options)
    else
      # Returns value if no attribute specified by form
      get_attributes[attribute] = value
    end
  end

  def parse_attribute(value, type, options = {})
    if options[:array]
      return [] if value.blank?
      value.map { |v| Lib::TypeCast::Base.type_cast(v, type) }.reject(&:blank?)
    else
      Lib::TypeCast::Base.type_cast(value, type)
    end
  end
end
