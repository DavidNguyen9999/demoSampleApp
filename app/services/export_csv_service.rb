require 'csv'

class ExportCsvService
  def microposts
    @obj = @objects.microposts.last_month
    @attributes = Micropost::CSV_ATTRIBUTES
    @header = Micropost::CSV_ATTRIBUTES.map { |attr| I18n.t("header_csv.#{attr}") }
    perform
  end

  def following
    @obj = @objects.following_last_month
    @attributes = User::CSV_ATTRIBUTES
    @header = User::CSV_ATTRIBUTES.map { |attr| I18n.t("header_csv.#{attr}") }
    perform
  end

  def followed
    @obj = @objects.followed_last_month
    @attributes = User::CSV_ATTRIBUTES
    @header = User::CSV_ATTRIBUTES.map { |attr| I18n.t("header_csv.#{attr}") }
    perform
  end

  def initialize objects
    @objects = objects
  end

  def perform
    CSV.generate do |csv|
      csv << header
      @obj.each do |object|
        csv << @attributes.map{ |attr| object.public_send(attr) }
      end
    end
  end

  private
  attr_reader :attributes, :obj, :header
end
