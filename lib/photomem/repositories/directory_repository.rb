class DirectoryRepository < Hanami::Repository

    def byId(input)
        directories.where {id.like(input)}.first
    end

    def byPathOrNew(input)
        directory = directories.read("SELECT * FROM directories WHERE directories.path = '#{input}'").first
        if directory
            return directory
        end
        return DirectoryRepository.new.create(path: input)
    end

    def byPath
        directories.order(:path)
    end

    def removeByParentPath(input)
        directories.read("SELECT * FROM directories WHERE directories.path LIKE '%#{input}%' AND path != '#{input}'").to_a.each do |directory|
            self.delete(directory.id)
        end
    end

    def bulkInsert(inputArray)
        command(:create, directories, use: [:timestamps], result: :many).call(inputArray)
    end
end
