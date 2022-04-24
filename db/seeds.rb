BRANDS_DATA = JSON.parse(File.read('db/brands.json'))
CARS_DATA = JSON.parse(File.read('db/cars.json'))

BRANDS = BRANDS_DATA.each.with_object({}) do |brand_item, memo|
  brand_name = brand_item['name']
  memo[brand_name] = Brand.create!(name: brand_name)
end

CARS_DATA.each do |car_item|
  Car.create!(
    model: car_item['model'],
    brand: BRANDS[car_item['brand_name']],
    price: car_item['price']
  )
end

User.create!(
  email: 'example@mail.com',
  preferred_price_range: 35_000...40_000,
  preferred_brands: [BRANDS['Alfa Romeo'], BRANDS['Volkswagen']]
)

User.create!(
  email: 'example1@mail.com',
  preferred_price_range: 15_000...45_000,
  preferred_brands: [BRANDS['Hyundai'], BRANDS['Nissan'], BRANDS['Saab']]
)
User.create!(
  email: 'example2@mail.com',
  preferred_price_range: 5_000...15_000,
  preferred_brands: [BRANDS['Saab'], BRANDS['Ram']]
)
User.create!(
  email: 'example3@mail.com',
  preferred_price_range: 55_000...90_000,
  preferred_brands: [BRANDS['Rolls-Royce']]
)

User.create!(
  email: 'example4@mail.com',
  preferred_price_range: 25_000...30_000,
  preferred_brands: [BRANDS['Audi'], BRANDS['Volkswagen'], BRANDS['BMW']]
)
