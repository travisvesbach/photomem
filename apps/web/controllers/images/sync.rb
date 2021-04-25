module Web
  module Controllers
    module Images
      class Sync
        include Web::Action

        ImageRepository.new.clear

        Dir.glob("./public/assets/sync/**/*.{jpg,png,JPG}").each do |file|
            miniImage = MiniMagick::Image.open(file)
            ImageRepository.new.create(path: file, date_taken: DateTime.strptime(miniImage.exif["DateTimeOriginal"], "%Y:%m:%d %R"))
        end

        def call(params)
            redirect_to routes.images_path
        end
      end
    end
  end
end
