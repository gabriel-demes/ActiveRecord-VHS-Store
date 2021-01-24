class Client < ActiveRecord::Base

    has_many :rentals
    has_many :vhs, through: :rentals
    
    def self.first_rental(client_info, vhs)
        client = create(client_info)
        Rental.create(client_id: client.id, vhs_id: vhs.id, current: true)
    end

    def self.most_active
        all.
    end
end