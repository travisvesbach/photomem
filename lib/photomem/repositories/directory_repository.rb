class DirectoryRepository < Hanami::Repository
    associations do
        has_many :images
    end

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

    def orderedByPath
        directories.order(:path)
    end

    def byPath(path)
        directories.read("SELECT * FROM directories WHERE directories.path LIKE '#{path}'").first
    end

    def byParentPath(input)
        directories.read("SELECT * FROM directories WHERE directories.path LIKE '%#{input}%' AND path != '#{input}'")
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
