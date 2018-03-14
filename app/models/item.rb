class Item < ActiveRecord::Base

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }

  def clearance!
    update_attributes!(
      status: 'clearanced',
      price_sold: style.wholesale_price * BigDecimal.new("0.75")
    )
  end

end
