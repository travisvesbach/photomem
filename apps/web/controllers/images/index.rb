module Web
  module Controllers
    module Images
      class Index
        include Web::Action

        expose :images

        def call(params)
            @images = ImageRepository.new.all
        end
      end
    end
  end
end
