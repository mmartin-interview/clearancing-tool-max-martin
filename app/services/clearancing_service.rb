require 'csv'
require 'ostruct'
class ClearancingService

  attr_accessor :clearancing_status

  def initialize
    self.clearancing_status = create_clearancing_status
  end

  def process_items(potential_item_ids)
    potential_item_ids.each do |potential_item_id|
      item_id_is_valid, error_message = clearancing_status.clearance_batch.item_id_is_valid?(potential_item_id.to_i)
      if item_id_is_valid
        clearancing_status.item_ids_to_clearance << potential_item_id.to_i
      else
        clearancing_status.errors << error_message
      end
    end

    clearance_items!(clearancing_status)
  end

  def clearance_items!(clearancing_status)
    if clearancing_status.item_ids_to_clearance.any?
      Item.transaction do
        clearancing_status.clearance_batch.save!
        clearancing_status.item_ids_to_clearance.each do |item_id|
          item_id_is_valid, error_message = clearancing_status.clearance_batch.item_id_is_valid?(item_id)
          if item_id_is_valid
            item = Item.find(item_id)
            item.clearance!
            clearancing_status.clearance_batch.items << item
          end
        end
      end
    end
    clearancing_status
  end

  def create_clearancing_status
    OpenStruct.new(
      clearance_batch: ClearanceBatch.new,
      item_ids_to_clearance: [],
      errors: [])
  end
end
