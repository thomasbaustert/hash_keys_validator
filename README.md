[![Build Status](https://travis-ci.org/thomasbaustert/hash_keys_validator.svg?branch=master)](https://travis-ci.org/thomasbaustert/hash_keys_validator)

# hash_keys_validator

Validates hash keys according to a whitelist.

## Installation

Add this line to your application's Gemfile:

    gem 'hash_keys_validator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_keys_validator

## Usage

The validator is initialized with the whitelist, for example: 

    validator = HashKeysValidator.new(whitelist: [:name, address: [:street, :city, email: [:type]]])

The whitelist contains the permitted (nested keys). In the example above the top level keys `name` 
and `address` are permitted. For the key `address` the nested keys `street`, `city` and `email` are
permitted. And for `email` the nested key `type` is permitted.

Validating the hash keys is done by calling `validate!` and passing the hash to be validated. 
If at least one (nested) hash key is not permitted (not in whitelist) an exception is raised:

    validator.validate!(name: 'John', unknown: 'dummy', address: { street: "John Street", unknown: "BANG", 
                                                                   email: { type: 'job', unknown: 'BANG' } })

    => raises HashKeysValidator::UnpermittedParametersError
       "found unpermitted parameters: unknown, address.unknown, address.email.unknown"

The list of unpermitted parameter names is provided via `exception.unpermitted_parameters`:
 
    ...
      validator.validate!(params)
    rescue HashKeysValidator::UnpermittedParametersError => ex
      ...
      ex.unpermitted_parameters # => ["unknown", "address.unknown", "address.email.unknown"] 
    end

