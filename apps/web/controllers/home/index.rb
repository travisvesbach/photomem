module Web
    module Controllers
        module Home
            class Index
                include Web::Action

                expose :images, :today, :directories

                def call(params)
                    @images = ImageRepository.new.all.to_a

                    @today = ImageRepository.new.takenToday.to_a

                    @directories = DirectoryRepository.new.orderedByPath.to_a
                end
            end
        end
    end
end
