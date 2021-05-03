module Web
    module Controllers
        module Directories
            class Update
                include Web::Action

                def call(params)
                    directory = DirectoryRepository.new.find(params[:id])

                    if params[:ignore] == 'true'
                        DirectoryRepository.new.update(directory.id, status: 'ignored')
                        directory.removeImages

                        directory.directories.each do |dir|
                            DirectoryRepository.new.update(dir.id, status: 'ignored')
                            dir.removeImages
                        end
                    end
                end
            end
        end
    end
end
