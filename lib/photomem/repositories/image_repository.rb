class ImageRepository < Hanami::Repository

    def takenToday
        images.read("SELECT * FROM images WHERE strftime( '%m', images.date_taken ) = strftime('%m','now') AND strftime( '%d', images.date_taken ) = strftime('%d','now')").to_a
    end

    def todayOrRandom
        images = self.takenToday

        if !images.any?
            images = self.all
        end

        images.sample
    end

    def bulkInsert(inputArray)
        command(:create, images, use: [:timestamps], result: :many).call(inputArray)
    end
end
