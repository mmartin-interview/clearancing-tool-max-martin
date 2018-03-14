class ClearanceBatch < ActiveRecord::Base

  require 'csv'

  has_many :items
  attr_accessor :item_errors

  def clearance_items!(potential_item_ids)
    self.item_errors = []
    if potential_item_ids.any?
      Item.transaction do
        potential_item_ids.each do |potential_item_id|
          if item_id_is_valid?(potential_item_id)
            item = Item.find(potential_item_id)
            item.clearance!
            self.items << item
          end
        end
      end
    end
  end

  def item_id_is_valid?(potential_item_id)
    if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
      self.item_errors << "Item #{potential_item_id} is not valid"
      return false
    end
    if Item.where(id: potential_item_id).none?
      self.item_errors << "Item #{potential_item_id} could not be found"
      return false
    end
    if Item.sellable.where(id: potential_item_id).none?
      self.item_errors << "Item #{potential_item_id} could not be clearanced"
      return false
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
