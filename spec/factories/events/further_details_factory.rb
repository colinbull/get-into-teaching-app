FactoryBot.define do
  factory :events_further_details, class: Events::Steps::FurtherDetails do
    privacy_policy { true }
    future_events { true }
    postcode { "TE57 1NG" }
  end
end