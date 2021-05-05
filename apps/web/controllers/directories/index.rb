module Web
    module Controllers
        module Directories
            class Index
                include Web::Action

                expose :directories, :image_count

                def call(params)
                    @directories = DirectoryRepository.new.orderedByPath.to_a

                    @image_count = @images = ImageRepository.new.all.to_a.count
                end
            end
        end
    end
end
