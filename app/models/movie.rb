class Movie < ActiveRecord::Base
    def self.all_ratings
        self.distinct.pluck(:rating)
    end
    
end
