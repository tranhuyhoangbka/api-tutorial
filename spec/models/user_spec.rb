require 'rails_helper'

RSpec.describe User, type: :model do
  describe "create a valid user" do
    before {@user = FactoryGirl.build(:user)}
    subject {@user}
    it {should respond_to(:email)}
    it {should respond_to(:password)}
    it {should respond_to(:password_confirmation)}
    it {is_expected.to be_valid}
  end

  describe "when email is not present" do
    before {@user = FactoryGirl.build(:user, email: "")}
    subject {@user}
    it {is_expected.not_to be_valid}
  end
  it { should have_many(:products) }

  describe "#products associtions" do
    before do
      @user = FactoryGirl.create :user
      3.times{FactoryGirl.create :product, user: @user}
    end
    it "destroys the associated products on self destruct" do
      products = @user.products
      @user.destroy
      products.each do |p|
        it{expect(Product.find(p.id)).to raise_error ActiveRecord::RecordNotFound}
      end
    end
  end
end
