class DeliveryLog
  def initialize(destination_address, order_id)
    @destination_address = destination_address
    @order_id = order_id
    @status = 'in_progress'
    @truck = nil
  end

  attr_reader

  def fail
    @status = 'error'
    result
  end

  def success
    @status = 'ok'
    result
  end

  def result
    { truck: truck, order_number: order_id, address: destination_address, status: status }
  end

  def add_truck(truck)
    @truck = truck
  end

  private

  attr_reader :order_id, :destination_address, :status, :truck
end
