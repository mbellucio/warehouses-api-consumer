require 'rails_helper'

describe 'User view homepage' do
  it 'and see warehouses' do
    warehouses = []
    warehouses << Warehouse.new(id: 1, name: 'Rio', code: 'SDU')
    warehouses << Warehouse.new(id: 2, name: 'Maceio', code: 'MCZ')
    allow(Warehouse).to receive(:all).and_return(warehouses)

    visit root_path

    expect(page).to have_content 'E-Commerce App'
    expect(page).to have_content 'Rio'
    expect(page).to have_content 'SDU'
    expect(page).to have_content 'Maceio'
    expect(page).to have_content 'MCZ'
  end

  it 'and theres no warehouses' do
    response = double('response', status: 200, body: "[]")
    allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/warehouses').and_return(response)

    visit root_path

    expect(page).to have_content 'No warehouses found.'
  end

  it 'e ve detalhes de um galpao' do
    data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    response = double('response', status: 200, body: data)
    allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/warehouses').and_return(response)

    data = File.read(Rails.root.join('spec/support/json/warehouse.json'))
    response = double('response', status: 200, body: data)
    allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/warehouses/1').and_return(response)

    visit root_path
    click_on 'Rio'

    expect(page).to have_content 'Rio'
    expect(page).to have_content 'SDU'
    expect(page).to have_content 'Rio de Janeiro'
    expect(page).to have_content '60000'
    expect(page).to have_content 'Test 1000'
    expect(page).to have_content '1000-00'
    expect(page).to have_content 'test'
  end

  it 'and its not possible to see the warehouse' do
    data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    response = double('response', status: 200, body: data)
    allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/warehouses').and_return(response)

    error_response = double('response', status: 500, body: '{}')
    allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/warehouses/1').and_return(error_response)

    visit root_path
    click_on 'Rio'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Something went wrong'
  end
end
