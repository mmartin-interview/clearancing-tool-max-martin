class Item < ActiveRecord::Base

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }

  CLEARANCE_PERCENTAGE = BigDecimal.new("0.75")

  def clearance!
    update_attributes!(
      status: 'clearanced',
      price_sold: style.wholesale_price * CLEARANCE_PERCENTAGE
    )
  end

end
