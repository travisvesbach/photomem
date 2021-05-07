module Web
    module Controllers
        module Directories
            class Sync
                include Web::Action

                def call(params)
                    directoryArray = []
                    Dir.glob("./public/assets/sync/**{,/*/**}/*/").each do |directory|
                        path = directory.reverse.partition("/").last.reverse.partition('assets/sync/').last
                        if !directoryArray.any? {|hash| hash.path == path}
                            directoryArray.append(DirectoryRepository.new.byPathOrNew(path))
                        end
                    end

                    # remove directories that no longer exist
                    DirectoryRepository.new.all.to_a.each do |dir|
                        if !directoryArray.any? {|hash| hash.path == dir.path}
                            DirectoryRepository.new.delete(dir.id)
                        end
                    end
                end
            end
        end
    end
end
