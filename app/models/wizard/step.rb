module Wizard
  class Step
    include ActiveModel::Model
    include ActiveModel::Attributes

    class << self
      def key
        name.split("::").last.underscore
      end
    end

    delegate :key, to: :class
    alias_method :id, :key

    def initialize(store, attributes = {}, *args)
      @store = store
      super(*args)
      assign_attributes attributes_from_store
      assign_attributes attributes
    end

    def save
      return false unless valid?

      persist_to_store
    end

    def persisted?
      !id.nil?
    end

  private

    def attributes_from_store
      @store.fetch attributes.keys.map(&:to_sym)
    end

    def persist_to_store
      @store.persist attributes
    end
  end
end
