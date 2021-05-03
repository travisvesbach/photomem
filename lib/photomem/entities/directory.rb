class Directory < Hanami::Entity
    # def getImageCount
    #     ImageRepository.new.byPathContains(self.path).to_a.length
    # end

    # def updateParentImageCount
    #     path = self.path.reverse.partition("/").last.reverse
    #     while path.length > 0
    #         parent = DirectoryRepository.new.byPath(path)
    #         DirectoryRepository.new.update(parent.id, path: parent.path, image_count: parent.getImageCount)
    #         path = path.reverse.partition("/").last.reverse
    #     end
    # end

    # def path
    #     if self.directory
    #         return self.directory.path + '/' + self.name
    #     else
    #         return 'assets/sync/' + self.name
    #     end
    # end

    def name
        return self.path.reverse.partition('/').first.reverse
    end

    def removeImages
        ImageRepository.new.removeByDirectoryId(self.id)
    end

    def directories
        DirectoryRepository.new.byParentPath(self.path).to_a
    end

    def syncImages
        # remove images in self
        self.removeImages
        # add all images in self
        imageArray = []
        Dir.glob("./public/assets/sync/#{self.path}/*.{jpg,png,JPG}").each do |file|
            miniImage = MiniMagick::Image.open(file)

            date_taken = miniImage.exif["DateTimeOriginal"] ? DateTime.strptime(miniImage.exif["DateTimeOriginal"], "%Y:%m:%d %R") : nil
            if date_taken == nil && miniImage.exif["DateTime"]
                date_taken = miniImage.exif["DateTime"]
            end
            name = file.reverse.partition("/").first.reverse
            imageArray.append({name: name, date_taken: date_taken, directory_id: self.id})

            if imageArray.length >= 100
                ImageRepository.new.bulkInsert(imageArray)
                imageArray = []
            end
        end

        if imageArray.length > 0
            ImageRepository.new.bulkInsert(imageArray)
        end

        DirectoryRepository.new.update(self.id, status: 'synced')
    end

    def imageCount
        ImageRepository.new.byDirectoryId(self.id).count
    end
end
