class Warehouse
  attr_accessor :name, :code, :zip, :address, :area, :city, :description, :id

  def initialize(name:, code:, id:)
    @name = name
    @code = code
    @id = id
  end

  def self.all
    warehouses = []

    response = Faraday.get('http://127.0.0.1:3000/api/v1/warehouses')
    if response.status == 200
      data = JSON.parse(response.body)

      data.each do |d|
        warehouses << Warehouse.new(name: d['name'], code: d['code'], id: d['id'])
      end
    end
    warehouses
  end
end
