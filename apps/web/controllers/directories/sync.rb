module Web
    module Controllers
        module Directories
            class Sync
                include Web::Action

                def call(params)
                    directory = DirectoryRepository.new.find(params[:id])

                    ImageRepository.new.removeByPathContains(directory.path)
                    DirectoryRepository.new.removeByParentPath(directory.path)

                    imageArray = []
                    directoryArray = []
                    Dir.glob("./public/assets/sync/#{directory.path}/**/*.{jpg,png,JPG}").each do |file|
                        miniImage = MiniMagick::Image.open(file)

                        date_taken = miniImage.exif["DateTimeOriginal"] ? DateTime.strptime(miniImage.exif["DateTimeOriginal"], "%Y:%m:%d %R") : nil
                        if date_taken == nil && miniImage.exif["DateTime"]
                            date_taken = miniImage.exif["DateTime"]
                        end
                        imageArray.append({path: file, date_taken: date_taken})

                        path = file.reverse.partition("/").last.reverse.partition('assets/sync/').last
                        if !directoryArray.any? {|hash| hash.path == path}
                            directoryArray.append(DirectoryRepository.new.byPathOrNew(path))
                        end

                        if imageArray.length >= 100
                            ImageRepository.new.bulkInsert(imageArray)
                            imageArray = []
                        end
                    end

                    if imageArray.length > 0
                        ImageRepository.new.bulkInsert(imageArray)
                    end

                    if directoryArray.length > 0
                        directoryArray.each do |dir|
                            DirectoryRepository.new.update(dir.id, path: dir.path, image_count: dir.getImageCount)
                        end
                    end
                end
            end
        end
    end
end
