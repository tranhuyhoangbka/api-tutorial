class Order < ActiveRecord::Base
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  validates :user_id, presence: true
  validates :total, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates_with EnoughProductsValidator

  before_validation :set_total!

  def set_total!
    self.total = placements.map{|pa| pa.product.price * pa.quantity}.sum
  end

  def build_placements_from_product_ids_and_quantity product_ids_and_quantity
    product_ids_and_quantity.each do |id_and_quantity|
      product_id, quantity = id_and_quantity.split ","
      self.placements.build product_id: product_id, quantity: quantity
    end
  end
end
