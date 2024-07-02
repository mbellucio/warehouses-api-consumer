class WarehousesController < ApplicationController
  def index
    @warehouses = Warehouse.all
  end

  def show
    response = Faraday.get("http://127.0.0.1:3000/api/v1/warehouses/#{params[:id]}")

    return @warehouse = JSON.parse(response.body) if response.status == 200

    redirect_to root_path, alert: 'Something went wrong'
  end
end
