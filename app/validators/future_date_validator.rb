class FutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && value <= Date.today
      record.errors.add(attribute, "Must be a future date")
    end
  end
end