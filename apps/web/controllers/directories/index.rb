module Web
    module Controllers
        module Directories
            class Index
                include Web::Action

                expose :directories

                def call(params)
                    @directories = DirectoryRepository.new.orderedByPath.to_a
                end
            end
        end
    end
end
