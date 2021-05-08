module Web
    module Controllers
        module Directories
            class Update
                include Web::Action

                def call(params)
                    directory = DirectoryRepository.new.find(params[:id])

                    if params[:ignore] == 'true'
                        directory.removeImages
                        DirectoryRepository.new.update(directory.id, status: 'ignored', image_count: 0, total_image_count: 0)

                        directory.directories.each do |dir|
                            dir.removeImages
                            DirectoryRepository.new.update(dir.id, status: 'ignored', image_count: 0, total_image_count: 0)
                        end
                    end

                    directory.parentDirectories.each do |dir|
                        dir.setTotalImageCount
                    end

                    directories = DirectoryRepository.new.orderedByPath.to_a
                    image_count = ImageRepository.new.all.to_a.count

                    output = [];
                    directories.each { |dir| output.push(dir.to_h) }

                    status 200, {directories: output, image_count: image_count}.to_json
                end
            end
        end
    end
end
