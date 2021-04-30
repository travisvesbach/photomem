class Directory < Hanami::Entity
    def getImageCount
        ImageRepository.new.byPathContains(self.path).to_a.length
    end

    def updateParentImageCount
        path = self.path.reverse.partition("/").last.reverse
        while path.length > 0
            parent = DirectoryRepository.new.byPath(path)
            DirectoryRepository.new.update(parent.id, path: parent.path, image_count: parent.getImageCount)
            path = path.reverse.partition("/").last.reverse
        end
    end
end
