class PrepareDelivery
  ValidationError = Class.new StandardError

  TRUCKS = { kamaz: 3000, gazel: 1000 }

  def initialize(order, destination_address, delivery_date)
    @order = order
    @destination_address = destination_address
    @delivery_date = delivery_date
  end

  def perform
    validate_delivery_date
    validate_address
    assign_truck
    validate_truck
    delivery_log.success
  rescue ValidationError
    delivery_log.fail
  end

  private

  attr_reader :order, :destination_address, :delivery_date

  def validate_address
    raise ValidationError, 'Нет адреса' if destination_address_empty?
  end

  def validate_delivery_date
    raise ValidationError, 'Дата доставки уже прошла' if delivery_date < Time.current
  end

  def validate_truck
    raise ValidationError, 'Нет машины' if delivery_log.result[:truck].nil?
  end

  def assign_truck
    TRUCKS.keys.each do |truck_title|
      delivery_log.add_truck(truck_title) if truck_supported?(truck_title)
    end
  end

  def destination_address_empty?
    destination_address.city.empty? || destination_address.street.empty? || destination_address.house.empty?
  end

  def truck_supported?(truck_title)
    TRUCKS[truck_title.to_sym] > delivery_weight
  end

  def delivery_log
    @delivery_log ||= DeliveryLog.new
  end

  def delivery_weight
    @delivery_weight ||= order.products.map(&:weight).sum
  end
end
