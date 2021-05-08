class Directory < Hanami::Entity
    def parentDirectories
        parents = []
        path = self.path.reverse.partition("/").last.reverse
        while path.length > 0
            parents.append(DirectoryRepository.new.byPath(path))
            path = path.reverse.partition("/").last.reverse
        end
        return parents
    end

    def directories
        DirectoryRepository.new.byParentPath(self.path).to_a
    end

    def setTotalImageCount
        count = self.image_count
        self.directories.each do |dir|
            count += dir.image_count
        end
        DirectoryRepository.new.update(self.id, total_image_count: count)
    end

    def syncImages
        DirectoryRepository.new.update(self.id, status: 'unsynced')
        # remove images in self
        self.removeImages

        # add all images in self
        imageArray = []
        Dir.glob("./public/assets/sync/#{self.path}/*.{jpg,png,JPG}").each do |file|
            miniImage = MiniMagick::Image.open(file)

            date_taken = miniImage.exif["DateTimeOriginal"] ? DateTime.strptime(miniImage.exif["DateTimeOriginal"], "%Y:%m:%d %R") : nil
            # if date_taken == nil && miniImage.exif["DateTime"]
            #     date_taken = miniImage.exif["DateTime"]
            # elsif date_taken == nil && miniImage["%[date:modify]"]
            #     date_taken = miniImage["%[date:modify]"]
            # end

            orientation = nil
            if miniImage.exif["Orientation"] == '1' or miniImage.exif["Orientation"] == '3' or miniImage[:width] > miniImage[:height]
                orientation = 'landscape'
            elsif miniImage.exif["Orientation"] == '6' or miniImage.exif["Orientation"] == '8' or miniImage[:width] < miniImage[:height]
                orientation = 'portrait'
            end

            name = file.reverse.partition("/").first.reverse
            imageArray.append({name: name, date_taken: date_taken, directory_id: self.id, orientation: orientation})

            if imageArray.length >= 100
                ImageRepository.new.bulkInsert(imageArray)
                imageArray = []
            end
        end

        if imageArray.length > 0
            ImageRepository.new.bulkInsert(imageArray)
        end

        DirectoryRepository.new.update(self.id, status: 'synced', image_count: ImageRepository.new.byDirectoryId(self.id).count)
    end

    def removeImages
        ImageRepository.new.byDirectoryId(self.id).to_a.each do |image|
            ImageRepository.new.delete(image.id)
        end
    end
end
