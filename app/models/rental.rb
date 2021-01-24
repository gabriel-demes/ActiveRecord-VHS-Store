class Rental < ActiveRecord::Base

    belongs_to :client
    belongs_to :vhs

    def due_date
        d_date = self.created_at + 7.days
    end

    def over_due?
        self.current && self.due_date < DateTime.now
    end

    def late_return?
        !self.current && self.due_date < self.updated_at
    end

    def self.past_due_date
        all.select{|rental| rental.overdue? || rental.late_return?}
    end

end