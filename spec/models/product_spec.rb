require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product){FactoryGirl.build :product}
  subject{product}

  it {is_expected.to respond_to :title}
  it {is_expected.to respond_to :price}
  it {is_expected.to respond_to :published}
  it {is_expected.to respond_to :user_id}
  it {is_expected.not_to be_published}

  it { should validate_presence_of :title }
  it { should validate_presence_of :price }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of :user_id }
  it { should belong_to :user }

  describe ".filter_by_title" do
    before do
      @product1 = FactoryGirl.create :product, title: "A plasma TV"
      @product2 = FactoryGirl.create :product, title: "Fastest Laptop"
      @product3 = FactoryGirl.create :product, title: "CD player"
      @product4 = FactoryGirl.create :product, title: "LCD TV"
    end

    context "when filter with 'TV' partterm" do
      let(:products){Product.filter_by_title("TV")}
      it "has two items is found" do
        expect(products.count).to eq 2
      end

      it "return products matching" do
        expect(products).to match_array [@product1, @product4]
      end
    end
  end

  describe ".above_or_equal_to_price" do
    before do
      @product1 = FactoryGirl.create :product, price: 10
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 80
      @product4 = FactoryGirl.create :product, price: 90
    end

    let(:products){Product.above_or_equal_to_price(60)}

    it "return two products greater than the price received" do
      expect(products.count).to eq 2
    end

    it "return products matching to price received" do
      expect(products).to match_array [@product3, @product4]
    end
  end

  describe ".under_or_equal_to_price" do
    before do
      @product1 = FactoryGirl.create :product, price: 10
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 80
      @product4 = FactoryGirl.create :product, price: 90
    end

    let(:products){Product.under_or_equal_to_price(85)}

    it "return three products match price received" do
      expect(products.count).to eq 3
    end

    it "return the products matching price received" do
      expect(products).to match_array [@product1, @product2, @product3]
    end
  end

  describe ".recent" do
    before do
      @product1 = FactoryGirl.create :product
      @product2 = FactoryGirl.create :product
      @product3 = FactoryGirl.create :product
      @product4 = FactoryGirl.create :product
      sleep 1
      @product4.touch
      sleep 1
      @product2.touch
    end
    let(:products){Product.recent}

    it "the products is sorted by updated time" do
      expect(products).to match_array [@product2, @product4, @product3, @product1]
    end
  end

  describe ".search" do
    before do
      @product1 = FactoryGirl.create :product, price: 100, title: "Plasma tv"
      @product2 = FactoryGirl.create :product, price: 50, title: "Videogame console"
      @product3 = FactoryGirl.create :product, price: 150, title: "MP3"
      @product4 = FactoryGirl.create :product, price: 99, title: "Laptop"
    end

    context "when title is tv and min price is 120" do
      let(:products){Product.search(title: "tv", min_price: 120)}
      it{expect(products).to eq []}
    end

    context "when title is 'mp3' and min price is 100 and max price is 150" do
      let(:products){Product.search(title: "mp3", min_price: 100, max_price: 150)}
      it{expect(products).to eq [@product3]}
    end

    context "when empty hash is sent" do
      let(:products){Product.search({})}
      it{expect(products).to match_array [@product1, @product2, @product3, @product4]}
    end

    context "when product_ids is sent" do
      let(:products){Product.search(product_ids: [@product1.id, @product2.id])}
      it{expect(products).to match_array [@product1, @product2]}
    end
  end
end
