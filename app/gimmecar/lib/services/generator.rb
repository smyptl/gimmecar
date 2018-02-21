class Lib::Services::Generator

  attr_reader :record, :rules, :query

  def initialize(record:, rules:, query:)
    @record = record
    @rules  = rules
    @query  = query
  end

  def retrieve
    create(rules: @rules, query: @query)
  end

  private

  def create(rules:, query:)
    send("create_#{rules.fetch(:type)}", rules: rules, query: query)
  end

  def create_object(rules:, query:)
    return nil if query.nil?

    output = {}
    output[:object] = name(rules)
    output[:id]     = id(rules, query)

    create_attributes(output: output, rules: rules, query: query)
  end

  def create_nested(rules:, query:)
    create_attributes(output: {}, rules: rules, query: query)
  end

  def create_collection(rules:, query:)
    output = {}
    output[:object] = :list
    output[:count]  = query.count

    output[:data] = []
    query.each do |query_item|
      output[:data] << create_object(rules: rules, query: query_item)
    end

    output
  end

  def create_attribute(rules:, query:)
    if rules[:options][:output]
      run(rules[:options][:output], query)
    else
      query.send(query_name(rules: rules))
    end
  end

  def create_attributes(output:, rules:, query:)
    rules.except(:id).fetch(:attributes).each do |_, rule|
      if include_attribute?(rules: rule, query: query)

        run_query = if [:collection, :object].include?(rule.fetch(:type))
                      query.send(query_name(rules: rule))
                    else
                      query
                    end

        output[rule.fetch(:name)] = create(rules: rule, query: run_query)
      end
    end

    output
  end

  def include_attribute?(rules:, query:)
    (rules[:options][:if] && run(rules[:options][:if], query)) || rules[:options][:if].blank?
  end

  def query_name(rules:)
    rules[:options][:as] || rules[:name]
  end

  def name(rules)
    rules[:name].to_s.singularize
  end

  def id(rules, query)
    query.send(rules.dig(:attributes, :id, :options, :as) || :id)
  end

  def run(method, query)
    record.instance_exec(query, &method)
  end
end
