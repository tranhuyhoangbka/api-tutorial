require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order){FactoryGirl.build :order}
  let(:order1){FactoryGirl.create :order}
  let(:product1){FactoryGirl.create :product}
  let(:product2){FactoryGirl.create :product}
  let(:product_ids_and_quantity){[[product1.id, product1.quantity], [product2.id, product2.quantity]]}

  subject{order}

  it{should respond_to :user_id}
  it{should respond_to :total}

  it{should validate_presence_of :user_id}
  it{should validate_presence_of :total}
  it{should validate_numericality_of(:total).is_greater_than_or_equal_to(0)}

  it{should have_many :placements}
  it{should have_many(:products).through(:placements)}

  describe "#build_placements_from_product_ids_and_quantity" do
    it "create 2 placements" do
      expect(order1.build_placements_from_product_ids_and_quantity(product_ids_and_quantity)).to change{order1.placements.size}.from(0).to(2)
    end
  end
end
