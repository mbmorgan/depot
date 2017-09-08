require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any? || product.image_url == nil
    assert product.errors[:price].any?
  end
  
  test "price must be positive and greater than 0.01" do
    product = Product.new(
      title: "Demo",
      description: "Test Description",
      image_url: "7apps.jpg"
    )
    
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    
    product.price = 1
    assert product.valid?
  end
  
  def new_product(image_url)
    Product.new(title: "New Product TT", description: "New Prod Description", price: 8.00, image_url: image_url)
  end
  
  test "image url" do
    ok = %w{ dcbang.jpg 7apps.jpg adrpo.jpg rails.png }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid, but isn't!"
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid!"
    end
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title, description: "unique title test description", price: 40, image_url: "rails.png")
    
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
  
end
