require 'csv'

class ClearanceBatchesController < ApplicationController

  def index
     @clearance_batches  = ClearanceBatch.all
   end

  def create
    potential_item_ids = process_file(params[:csv_batch_file].tempfile)
    service = ClearancingService.new
    service.process_items(potential_item_ids)
    alert_messages = []
    if service.clearancing_status.errors.any?
      alert_messages << "#{service.clearancing_status.errors.count} item id(s) raised errors and were not clearanced"
      service.clearancing_status.errors.each {|error| alert_messages << error }
      flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    end
    flash[:notice]  = "#{service.clearancing_status.clearance_batch.items.count} item(s) clearanced in batch #{service.clearancing_status.clearance_batch.id}"
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
