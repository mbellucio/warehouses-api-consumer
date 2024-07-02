require 'rails_helper'

describe Warehouse do
  context '.all' do
    it 'return all warehouses' do
      data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
      response = double('response', status: 200, body: data)
      allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/warehouses').and_return(response)

      result = Warehouse.all

      expect(result.length).to eq 2
      expect(result[0].name).to eq 'Rio'
      expect(result[0].code).to eq 'SDU'
      expect(result[1].name).to eq 'Maceio'
      expect(result[1].code).to eq 'MCZ'
    end

    it 'return empty if API is not reachable' do
      response = double('response', status: 500, body: '[]')
      allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/warehouses').and_return(response)

      result = Warehouse.all

      expect(result).to eq []
    end
  end
end
  