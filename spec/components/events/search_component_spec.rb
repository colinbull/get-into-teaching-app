require "rails_helper"

describe Events::SearchComponent, type: "component" do
  let(:search) { build(:events_search) }
  let(:path) { "/some/path" }

  subject! { render_inline(Events::SearchComponent.new(search, path)) }

  specify "builds a search form" do
    expect(page).to have_css("form[action='#{path}'][method='get']")
  end

  describe "fields" do
    [
      { attribute: :type, label: "Event type", element: :select },
      { attribute: :distance, label: "Distance", element: :select },
      { attribute: :postcode, label: "Postcode", element: :input },
      { attribute: :month, label: "Month", element: :select },
    ].each do |field|
      describe field[:label] do
        specify "is present" do
          expect(page).to have_css("#{field[:element]}[name='events_search[#{field[:attribute]}]']")
        end

        specify "is correctly-labelled" do
          expect(page).to have_css("label[for='events_search_#{field[:attribute]}']")
          expect(page).to have_css("#{field[:element]}[id='events_search_#{field[:attribute]}']")
        end
      end
    end
  end
end
