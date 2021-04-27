module Web
    module Controllers
        module Home
            class Index
                include Web::Action

                expose :images, :today

                def call(params)
                    @images = ImageRepository.new.all

                    @today = ImageRepository.new.takenToday
                end
            end
        end
    end
end
