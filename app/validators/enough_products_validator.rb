class EnoughProductsValidator < ActiveModel::Validator
  def validate(record)
    record.placements.each do |placement|
      if placement.quantity > placement.product.quantity
        record.errors["#{placement.product.title}"] << "Is out of stock, just #{placement.product.quantity} left"
      end
    end
  end
end
