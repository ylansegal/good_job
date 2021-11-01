# frozen_string_literal: true
require 'rails_helper'

RSpec.describe GoodJob::Filterable do
  let(:model_class) { GoodJob::Execution }
  let!(:execution) { model_class.create(active_job_id: SecureRandom.uuid, queue_name: "default", serialized_params: { example_key: 'example_value' }, error: "ExampleError: a message") }

  describe '.search' do
    it 'searches serialized params' do
      expect(model_class.search('example_value')).to include(execution)
    end

    it 'searches record id' do
      expect(model_class.search(execution.id)).to include(execution)
    end

    it 'searches errors' do
      expect(model_class.search('ExampleError')).to include(execution)
    end

    it 'filters out non-matching records' do
      expect(model_class.search('ghost')).to be_empty
    end

    it 'is chainable and reversible' do
      expect(model_class.where.not(id: nil).search('example_value').reverse).to include(execution)
    end
  end
end