module Web
    module Controllers
        module Images
            class Sync
                include Web::Action

                def call(params)
                    ImageRepository.new.clear

                    imageArray = []
                    Dir.glob("./public/assets/sync/**/*.{jpg,png,JPG}").each do |file|
                        miniImage = MiniMagick::Image.open(file)

                        date_taken = miniImage.exif["DateTimeOriginal"] ? DateTime.strptime(miniImage.exif["DateTimeOriginal"], "%Y:%m:%d %R") : nil
                        if date_taken == nil && miniImage.exif["DateTime"]
                            date_taken = miniImage.exif["DateTime"]
                        end
                        imageArray.append({path: file, date_taken: date_taken})

                        if imageArray.length >= 100
                            ImageRepository.new.bulkInsert(imageArray)
                            imageArray = []
                        end
                    end
                    if imageArray.length > 0
                        ImageRepository.new.bulkInsert(imageArray)
                    end
                end
            end
        end
    end
end
