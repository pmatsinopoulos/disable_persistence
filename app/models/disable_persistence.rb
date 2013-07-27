module DisablePersistence
  extend ActiveSupport::Concern

  def disable_persistence
    @persistence_disabled = true
  end

  def enable_persistence
    @persistence_disabled = false
  end

  module ClassMethods
    def disable_persistence
      @@class_persistence_disabled = true
    end

    def enable_persistence
      @@class_persistence_disabled = false
    end

    def persistence_disabled?
      @@class_persistence_disabled ||= false
    end

    def persistence_disabled
      persistence_disabled?
    end
  end

  included do
    attr_reader :persistence_disabled
    alias :persistence_disabled? :persistence_disabled

    before_save :can_persist?

    after_initialize do |base|
      base.instance_variable_set(:@persistence_disabled, false)
    end

    def can_persist?
      !persistence_disabled? && !self.class.persistence_disabled?
    end

    protected :can_persist?
  end
end

ActiveRecord::Base.send :include, DisablePersistence

