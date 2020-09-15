class Movie < ActiveRecord::Base
    
    def self.all_ratings
        ratings= Array.new
        self.select(:rating).distinct.each {|x| ratings.push(x.rating)}
        ratings
    end
    def self.with_ratings(filter_ratings)
        filter_movies = self.all.where({rating: filter_ratings})
        filter_movies
    end
    
end
