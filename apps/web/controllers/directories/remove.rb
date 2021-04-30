module Web
    module Controllers
        module Directories
            class Remove
                include Web::Action

                def call(params)
                    directory = DirectoryRepository.new.find(params[:id])

                    ImageRepository.new.removeByPathContains(directory.path)
                    DirectoryRepository.new.removeByParentPath(directory.path)

                    directory.updateParentImageCount

                    DirectoryRepository.new.delete(params[:id])
                end
            end
        end
    end
end
