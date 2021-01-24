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


end