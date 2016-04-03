class Product < ActiveRecord::Base
  SCOPES_HASH = {
    title: :filter_by_title,
    min_price: :above_or_equal_to_price,
    max_price: :under_or_equal_to_price
  }

  belongs_to :user

  validates :title, :user_id, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}

  scope :filter_by_title, ->(keyword){where("lower(title) LIKE ?", "%#{keyword.downcase}%")}
  scope :above_or_equal_to_price, ->(price){where("price >= ?", price)}
  scope :under_or_equal_to_price, ->(price){where("price <= ?", price)}
  scope :recent, ->{order("updated_at DESC")}

  class << self
    def search params = {}
      if params[:product_ids].present?
        Product.where id: params[:product_ids]
      else
        products = Product.recent
        SCOPES_HASH.each do |search_type, name_scope|
          if params[search_type].present?
            products = products.send name_scope, params[search_type]
          end
        end
        products
      end
    end
  end
end
