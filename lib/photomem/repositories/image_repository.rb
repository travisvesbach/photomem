class ImageRepository < Hanami::Repository
    associations do
        belongs_to :directory
    end

    def takenToday()
        images.read("SELECT * FROM images WHERE strftime( '%m', images.date_taken ) = strftime('%m','now', 'localtime') AND strftime( '%d', images.date_taken ) = strftime('%d','now', 'localtime')")
    end

    def todayOrRandom(orientation = nil)
        query = "SELECT * FROM images WHERE strftime( '%m', images.date_taken ) = strftime('%m','now', 'localtime') AND strftime( '%d', images.date_taken ) = strftime('%d','now', 'localtime')"
        if orientation
            query = query + " AND images.orientation LIKE '#{orientation}'"
            found = images.read(query).to_a
            if !found.any?
                found = self.byOrientation(orientation).to_a
            end
        else
            found = images.read(query).to_a
            if !found.any?
                found = self.all.to_a
            end
        end
        found.sample
    end

    def random(orientation = nil)
        if orientation
            found = self.byOrientation(orientation).to_a
        else
            found = self.all.to_a
        end
        found.sample
    end

    def bulkInsert(input)
        command(:create, images, use: [:timestamps], result: :many).call(input)
    end

    def byDirectoryId(input)
        images.where(directory_id: input)
    end

    def byOrientation(orientation)
        images.read("SELECT * FROM images WHERE images.orientation LIKE '#{orientation}'")
    end

    def byDirectoryIdAndName(directory_id, name)
        images.where(directory_id: directory_id).where(name: name)
    end
end
