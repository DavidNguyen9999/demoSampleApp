# frozen_string_literal: true

# Class ExportCsvController
class ExportCsvController < ApplicationController
  def index
    add_csv_to_zip
    respond_to do |format|
      format.zip do
        @compressed_filestream.rewind
        send_data @compressed_filestream.read, filename: 'CSV.zip'
      end
    end
  end

  private

  def export_csv
    csv_files = {}
    export_csv_service = ExportCsvService.new current_user
    csv_files[:csv_post] = export_csv_service.microposts
    csv_files[:csv_following] = export_csv_service.following
    csv_files[:csv_followers] = export_csv_service.followed
    csv_files
  end

  def add_csv_to_zip
    @compressed_filestream = Zip::OutputStream.write_buffer do |f|
      export_csv.each do |key, value|
        f.put_next_entry "#{key}.csv"
        f.print value
      end
    end
  end
end
