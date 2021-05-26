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
    @hash[:csv_post] = ExportCsvService.new current_user.microposts.last_month, Micropost::CSV_ATTRIBUTES
    @hash[:csv_following] = ExportCsvService.new current_user.following_last_month, User::CSV_ATTRIBUTES
    @hash[:csv_followers] = ExportCsvService.new current_user.followed_last_month, User::CSV_ATTRIBUTES
  end

  def add_hash_csv_to_zip
    @compressed_filestream = Zip::OutputStream.write_buffer do |f|
      @hash.each do |key, value|
        f.put_next_entry "#{key}.csv"
        f.print value.perform
      end
    end
  end
end
