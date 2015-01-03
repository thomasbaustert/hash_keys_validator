require 'spec_helper'
require 'hash_keys_validator'

describe HashKeysValidator do
  let(:whitelist) { [:name, address: [:street, :city, email: [:type]]] }

  describe "#validate!" do
    context "unpermitted names given" do
      it "raises UnpermittedParametersError with all parameter names" do
        validator = described_class.new(whitelist: whitelist)
        raw_params = { name: 'John', unknown: 'dummy', address: { street: "John Street", unknown: "BANG",
                                                                  email: { type: 'job', unknown: 'BANG' } } }

        expect {
          validator.validate!(raw_params)
        }.to raise_error(HashKeysValidator::UnpermittedParametersError) { |ex|
          expect(ex.message).to match /found unpermitted parameters: unknown, address.unknown, address.email.unknown/
          expect(ex.unpermitted_parameters).to match_array ['unknown', 'address.unknown', 'address.email.unknown']
        }
      end

      it "accepts stringified keys to" do
        validator = described_class.new(whitelist: whitelist)

        expect {
          validator.validate!('name' => 'John', 'unknown' => 'dummy',
                              'address' => { 'street' => "John Street", 'unknown' => "BANG",
                                             'email' => { 'type' => 'job', 'unknown' => 'BANG' } })
        }.to raise_error(HashKeysValidator::UnpermittedParametersError) { |ex|
          expect(ex.unpermitted_parameters).to match_array ['unknown', 'address.unknown', 'address.email.unknown']
        }
      end
    end

    context "valid names given" do
      it "does not raise error" do
        validator = described_class.new(whitelist: whitelist)
        raw_params = { name: 'John Doe', address: { street: 'John Street', city: 'London', email: { type: 'job' } } }

        expect { validator.validate!(raw_params) }.to_not raise_error
      end
    end
  end

end