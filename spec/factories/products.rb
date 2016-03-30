FactoryGirl.define do
  #after(:create){|product| (FactoryGirl.create(:user)).products << product}

  factory :product do
    title {Faker::Book.title}
    price {Faker::Number.decimal(2)}
    published false
    user
  end
end
