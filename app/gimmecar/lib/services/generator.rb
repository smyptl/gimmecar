class Lib::Services::Generator

  attr_reader :rules, :query

  def initialize(rules:, query:)
    @rules = rules
    @query = query
  end

  def fetch
    create(rules: @rules, query: @query)
  end

  private

  def create(rules:, query:)
    send("create_#{rules.fetch(:type)}", rules: rules, query: query)
  end

  def create_object(rules:, query:)
    output = {}
    output['object'] = name(rules)
    output['id']     = id(rules, query)

    rules.except('id').fetch(:attributes).each do |_, rule|
      if rule.fetch(:type) == :value
        if (rule[:options][:if] && rule[:options][:if].call(query)) || rule[:options][:if].blank?
          output[name(rule)] = value(rules: rule, query: query)
        end
      else
        q = query.send(query_name(rules: rule))
        output[name(rule)] = create(rules: rule, query: q)
      end
    end

    output
  end

  def create_collection(rules:, query:)
    output = {}
    output['object'] = :list
    output['count']  = query.count

    output['data'] = []
    query.each do |q|
      output['data'] << create_object(rules: rules, query: q)
    end

    output
  end

  def value(rules:, query:)
    if rules[:options][:output]
      rules[:options][:output].call(query)
    else
      query.send(query_name(rules: rules))
    end
  end

  def query_name(rules:)
    rules[:options][:as] || rules[:name]
  end

  def name(rules)
    rules[:name].to_s.singularize
  end

  def id(rules, query)
    query.send(rules[:as] || :id)
  end
end
