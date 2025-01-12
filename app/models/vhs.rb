class Vhs < ActiveRecord::Base
    belongs_to :movie
    has_many :rentals
    has_many :clients, through: :rentals
    
    after_initialize :add_serial_number


    def can_be_rented?
        Rental.find_by(vhs_id: self.id, current: false)
    end

    def rented_before?
        !Rental.find_by(vhs_id: self.id).nil?
    end

    def self.hot_from_the_press(movie_info, genre_name)
        movie = Movie.create(movie_info)
        genre = Genre.find_by_name(genre_name)
        if !genre
            genre = Genre.create(genre_name)
        end
        MovieGenre.create(movie_id: movie.id, genre_id: genre.id)
        3.times {Vhs.create(movie_id: movie.id)}
    end





    private

    # generates serial number based on the title
    def add_serial_number
        serial_number = serial_number_stub
        # Converting to Base 36 can be useful when you want to generate random combinations of letters and numbers, since it counts using every number from 0 to 9 and then every letter from a to z. Read more about base 36 here: https://en.wikipedia.org/wiki/Senary#Base_36_as_senary_compression
        alphanumerics = (0...36).map{ |i| i.to_s 36 }
        13.times{|t| serial_number << alphanumerics.sample}
        self.update(serial_number: serial_number)
    end

    def long_title?
        self.movie.title && self.movie.title.length > 2
    end

    def two_part_title?
        self.movie.title.split(" ")[1] && self.movie.title.split(" ")[1].length > 2
    end

    def serial_number_stub
        return "X" if self.movie.title.nil?
        return self.movie.title.split(" ")[1][0..3].gsub(/s/, "").upcase + "-" if two_part_title?
        return self.movie.title.gsub(/s/, "").upcase + "-" unless long_title?
        self.movie.title[0..3].gsub(/s/, "").upcase + "-"
    end
end