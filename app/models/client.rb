class Client < ActiveRecord::Base

    has_many :rentals
    has_many :vhs, through: :rentals
    

    def self.first_rental(client_info, movie_title)
        client = Client.create(client_info)
        movie = Movie.find_by_title(movie_title)
        copies = Vhs.where(movie_id: movie.id)
        can_rent = copies.find{|copy| copy.can_be_rented? || copy.rented_before?}
        Rental.create(vhs_id: can_rent.id, client_id: client.id, current: true)
    end

    def current_rentals
        Rental.where(client_id: self.id, current: true)
    end

    def returned_rentals
        Rental.where(client_id:self.id, current:false)
    end

    def self.most_active
        all.max_by(5){|client| client.returned_rentals.length}
    end

    def favorite_genre
        genres =vhs.map(&:movie).map(&:genres).flatten
        favorite_genre = genres.max_by{|genre| genres.count(genre)}
        puts favorite_genre.name
    end

    def self.non_grata
        Rental.past_due_date.map(&:client)  #...map{|rental| rental.client}
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

    def self.total_watch_time
        Rental.all.length
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