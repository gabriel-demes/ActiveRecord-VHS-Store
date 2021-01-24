class Client < ActiveRecord::Base

    has_many :rentals
    has_many :vhs, through: :rentals
    

    def self.first_rents(client_info, movie_title)
        client = Client.create(client_info)
        movie = Movie.find_by_title(movie_title)
        copies = Vhs.where(movie_id: movie.id)
        can_rent = copies.find{|copy| copy.can_be_rented?}
        Rental.create(vhs_id: can_rent.id, client_id: client.id, current: true)
    end

    def self.paid_most
        most_paid = all[0] #all[0] just means client 1
        all.each do |client|
            if client.rentals.length > most_paid.rentals.length
                most_paid = client
            end
        end
        most_paid
    end

    def return_one(vhs)
        rental = Rental.find_by(client_id: self.id, vhs_id: vhs.id)
        rental.update(current: false)
    end

    def return_all
        rentals = Rental.where(client_id: self.id, current: true)
        rentals.update_all(current: false)
    end

    def last_return
        self.return_all
        client = Client.find(self.id)
        client.destroy
    end
end