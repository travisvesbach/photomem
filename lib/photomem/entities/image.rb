class Image < Hanami::Entity
    def path
        return './public/assets/sync/' + self.directory.path + '/' + self.name
    end

    def directory
        return DirectoryRepository.new.byId(self.directory_id)
    end
end
