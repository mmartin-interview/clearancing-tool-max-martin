require 'csv'

class ClearanceBatchesController < ApplicationController

  def index
     @clearance_batches  = ClearanceBatch.all
   end

  def create
    clearance_batch = ClearanceBatch.create
    potential_item_ids = process_file(params[:csv_batch_file].tempfile)
    clearance_batch.clearance_items!(potential_item_ids)
    alert_messages = []
    if clearance_batch.item_errors && clearance_batch.item_errors.any?
      alert_messages << "#{clearance_batch.item_errors.count} item id(s) raised errors and were not clearanced"
      clearance_batch.item_errors.each {|error| alert_messages << error }
      flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    end
    clearance_batch.reload
    flash[:notice]  = "#{clearance_batch.items.count} item(s) clearanced in batch #{clearance_batch.id}"
    redirect_to action: :index
  end

  def show
    @batch = ClearanceBatch.find(params[:id])
    @items = @batch.items.includes(:style)
    @total_cost = @items.map(&:price_sold).sum
    respond_to do |format|
      format.html
      format.csv { send_data @batch.to_csv, filename: "batch-#{@batch.id}.csv" }
    end
  end

  private

  def process_file(uploaded_file)
    potential_item_ids = []
    CSV.foreach(uploaded_file, headers: false) do |row|
      potential_item_ids << row[0].to_i
    end
    return potential_item_ids
  end

end
