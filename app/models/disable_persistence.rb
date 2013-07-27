module DisablePersistence
  extend ActiveSupport::Concern

  def disable_persistence
    self.persistence_disabled = true
  end

  def enable_persistence
    self.persistence_disabled = false
  end

  included do
    attr_accessor :persistence_disabled
    alias :persistence_disabled? :persistence_disabled

    before_save :check_for_persistence_flag

    after_initialize do |base|
      base.persistence_disabled = false
    end

    def check_for_persistence_flag
     !persistence_disabled?
    end

    protected :check_for_persistence_flag
  end
end

ActiveRecord::Base.send :include, DisablePersistence

