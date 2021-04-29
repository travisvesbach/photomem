class Directory < Hanami::Entity
    def getImageCount
        ImageRepository.new.byPathContains(self.path).to_a.length
    end
end
