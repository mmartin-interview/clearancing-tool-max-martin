class ClearanceBatch < ActiveRecord::Base

  require 'csv'

  has_many :items
  attr_accessor :item_errors

  def item_id_is_valid?(potential_item_id)
    if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
      return false, "Item #{potential_item_id} is not valid"
    end
    if Item.where(id: potential_item_id).none?
      return false, "Item #{potential_item_id} could not be found"
    end
    if Item.sellable.where(id: potential_item_id).none?
      return false, "Item #{potential_item_id} could not be clearanced"
    end
    return true
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w{Item Name Size Color Price}
      items.each do |item|
        csv << [item.style.type, item.style.name, item.size, item.color, sprintf("%.2f", item.price_sold || 0)]
      end
    end
  end

end
