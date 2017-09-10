FactoryGirl.define do
  factory :api_backend_url_match do
    sequence(:frontend_prefix) { |n| "/example-frontend/#{n}/" }
    backend_prefix "/example-backend/"
    sequence(:sort_order) { |n| n }
  end
end
