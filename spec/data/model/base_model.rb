# frozen_string_literal: true

class BaseModel
  attr_accessor :persisted

  def initialize
    @persisted = false
  end

  def persisted?
    persisted
  end

  def save!
    Object.const_get("Services::#{self.class.name}Creator").create(self)
  rescue StandardError => e
    puts "#{e.class}: #{e.message.gsub(/([^\n]*)(\n.*)?/m, '\1')} (exception raised in #{self.class.name}Creator."
    raise e
  end

  def save
    save!
    self.persisted = true
    true
  rescue StandardError
    false
  end
end