class ImageRepository < Hanami::Repository
    associations do
        belongs_to :directory
    end

    def takenToday
        images.read("SELECT * FROM images WHERE strftime( '%m', images.date_taken ) = strftime('%m','now') AND strftime( '%d', images.date_taken ) = strftime('%d','now')")
    end

    def todayOrRandom
        images = self.takenToday.to_a

        if !images.any?
            images = self.all
        end

        images.sample
    end

    def bulkInsert(inputArray)
        command(:create, images, use: [:timestamps], result: :many).call(inputArray)
    end

    # def byPathContains(input)
    #     images.read("SELECT * FROM images WHERE images.path LIKE '%#{input}%'")
    # end

    def byDirectoryId(input)
        images.where(directory_id: input)
    end

    def removeByPathContains(input)
        images.read("SELECT * FROM images WHERE images.path LIKE '%#{input}%'").to_a.each do |image|
            self.delete(image.id)
        end
    end

    def removeByDirectoryId(input)
        images.read("SELECT * FROM images WHERE images.directory_id = #{input}").to_a.each do |image|
            self.delete(image.id)
        end
    end
end
