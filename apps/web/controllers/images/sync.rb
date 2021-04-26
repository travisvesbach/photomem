module Web
  module Controllers
    module Images
      class Sync
        include Web::Action


        def call(params)
            ImageRepository.new.clear

            Dir.glob("./public/assets/sync/**/*.{jpg,png,JPG}").each do |file|
                miniImage = MiniMagick::Image.open(file)
                ImageRepository.new.create(path: file, date_taken: DateTime.strptime(miniImage.exif["DateTimeOriginal"], "%Y:%m:%d %R"))
            end

            redirect_to routes.images_path
        end
      end
    end
  end
end
