class Report < ApplicationRecord
    belongs_to :user
    validates :start, presence: true
    validate :correct_dates

    private
        def correct_dates
            if start != nil
                if finish != nil
                    if start > finish
                        errors.add(:start, "cannot be later than finish")
                    end
                end
            end
        end
end
