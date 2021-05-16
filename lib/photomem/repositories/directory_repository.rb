class DirectoryRepository < Hanami::Repository
    associations do
        has_many :images
    end

    def byId(input)
        directories.where {id.like(input)}.first
    end

    def byPathOrNew(input)
        # directory = directories.read("SELECT * FROM directories WHERE directories.path = \"#{input}\"").first
        directory = self.byPath(input)
        if directory
            return directory
        end
        parent = self.byPath(input.reverse.partition("/").last.reverse)
        status = parent && parent.status == 'ignored' ? 'ignored' : 'unsynced'
        return self.create(path: input, status: status)
    end

    def orderedByPath
        directories.order(:path).to_a.sort_by! {|dir| dir.path.gsub(' ', '') }
    end

    def byPath(input)
        directories.read("SELECT * FROM directories WHERE directories.path LIKE \"#{input}\"").first
    end

    def byParentPath(input)
        directories.read("SELECT * FROM directories WHERE directories.path LIKE \"%#{input}%\" AND path != \"#{input}\"")
    end

    def bulkInsert(input)
        command(:create, directories, use: [:timestamps], result: :many).call(input)
    end
end
