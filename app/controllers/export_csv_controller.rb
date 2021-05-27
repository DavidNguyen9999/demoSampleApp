# frozen_string_literal: true

# Class ExportCsvController
class ExportCsvController < ApplicationController
  def index
    export_csv_to_hash
    add_hash_csv_to_zip
    respond_to do |format|
      format.zip do
        @compressed_filestream.rewind
        send_data @compressed_filestream.read, filename: 'CSV.zip'
      end
    end
  end

  private

  def export_csv_to_hash
    @hash = {}
    export_csv_service = ExportCsvService.new current_user
    @hash[:csv_post] = export_csv_service.microposts
    @hash[:csv_following] = export_csv_service.following
    @hash[:csv_followers] = export_csv_service.followed
  end

  def add_hash_csv_to_zip
    @compressed_filestream = Zip::OutputStream.write_buffer do |f|
      @hash.each do |key, value|
        f.put_next_entry "#{key}.csv"
        f.print value
      end
    end
  end
end
