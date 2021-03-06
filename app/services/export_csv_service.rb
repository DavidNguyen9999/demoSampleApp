require 'csv'

class ExportCsvService
  def initialize current_user
    @user = current_user
  end

  def microposts
    @data = @user.microposts.last_month
    @attributes = Micropost::CSV_ATTRIBUTES
    @header = Micropost::CSV_ATTRIBUTES.map { |attr| I18n.t("header_csv.#{attr}") }
    perform
  end

  def following
    @data = @user.following_last_month
    @attributes = User::CSV_ATTRIBUTES
    @header = User::CSV_ATTRIBUTES.map { |attr| I18n.t("header_csv.#{attr}") }
    perform
  end

  def followed
    @data = @user.followed_last_month
    @attributes = User::CSV_ATTRIBUTES
    @header = User::CSV_ATTRIBUTES.map { |attr| I18n.t("header_csv.#{attr}") }
    perform
  end

  def perform
    CSV.generate do |csv|
      csv << header
      @data.each do |object|
        csv << @attributes.map{ |attr| object.public_send(attr) }
      end
    end
  end

  private
  attr_reader :attributes, :current_user, :header
end
