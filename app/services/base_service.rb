class BaseService
  include ActiveModel::Model

  class << self
    def call(*args)
      new(*args).call
    end
  end

  def call
    return false unless valid?

    @success = call_after_validation

    return @success
  end

  def call_after_validation
    raise NotImplementedError.new("#{self.class.name}#call_after_validation is an abstract method.")
  end

  def clone_errors(model)
    return unless model

    model.errors.each do |attribute, error|
      errors.add(attribute, error)
    end
  end
end
