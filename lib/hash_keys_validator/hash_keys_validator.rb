class HashKeysValidator

  class HashKeysValidatorError < StandardError
  end

  class UnpermittedParametersError < HashKeysValidatorError
    attr_reader :unpermitted_parameters

    def initialize(names = nil)
      @unpermitted_parameters = Array(names)
    end

    def to_s
      "found unpermitted parameters: #{unpermitted_parameters.join(', ')}"
    end
  end

  def initialize(options = {})
    @whitelist = options[:whitelist] || {}
  end

  ##
  # Validates given parameters.
  # Raises UnpermittedParametersError with all unpermitted parameter names if any unpermitted parameter exists.
  #
  def validate!(raw_parameters = {})
    valid_names = build_names(convert_to_hash(@whitelist))
    given_names = build_names(raw_parameters)
    unpermitted_names = given_names - valid_names

    raise HashKeysValidator::UnpermittedParametersError.new(unpermitted_names) unless unpermitted_names.empty?
  end

  private

    #  IN: { name: 'John', address: { street: "John Street", email: { type: 'job' } } }
    # OUT: ["name", "address", "address.street", "address.email", "address.email.type"]
    def build_names(params = {})
      list = []
      _build_names(list, nil, params)
      list
    end

    def _build_names(list, prefix, params)
      params.each_pair do |key, value|
        name = prefix.nil? ? key.to_s : "#{prefix}.#{key.to_s}"
        list << name
        if value.is_a?(Hash)
          _build_names(list, name, params[key])
        end
      end
    end

    #  IN: [:name, address: [:street, :city, email: [:type]]]
    # OUT: {name: nil, address: { street: nil, city: nil, email: { type: nil }}}
    def convert_to_hash(whitelist = [])
      hash = {}
      whitelist.each do |entry|
        if entry.is_a?(Hash)
          k, v = entry.keys.first, entry[entry.keys.first]
          hash[k] = convert_to_hash(v)
        else
          hash[entry] = nil
        end
      end
      hash
    end

    # TODO/02.01.15/11:14/tb move to core_ext/ruby/hash.rb
    def symbolize_recursive(hash)
      {}.tap do |h|
        hash.each { |key, value| h[key.to_sym] = map_value(value) }
      end
    end

    def map_value(thing)
      case thing
      when Hash
        symbolize_recursive(thing)
      when Array
        thing.map { |v| map_value(v) }
      else
        thing
      end
    end
end