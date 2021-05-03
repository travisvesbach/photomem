module Web
    module Controllers
        module Images
            class Sync
                include Web::Action

                def call(params)
                    directory = DirectoryRepository.new.find(params[:id])

                    # when syncing an ignored directory, ignored parents should be synced
                    if directory.status == 'ignored'
                        directory.parentDirectories.each do |dir|
                            if dir.status == 'ignored'
                                dir.syncImages
                            end
                        end
                    end

                    # remove directory images and sync
                    directory.removeImages
                    directory.syncImages

                    # create child directories that don't exist
                    directoryArray = []
                    Dir.glob("./public/assets/sync/#{directory.path}/**/*/").each do |dir|
                        path = dir.reverse.partition("/").last.reverse.partition('assets/sync/').last
                        if !directoryArray.any? {|hash| hash.path == path}
                            directoryArray.append(DirectoryRepository.new.byPathOrNew(path))
                        end
                    end

                    # sync child directories
                    directory.directories.each do |dir|
                        # remove directory if it no longer exists
                        if !directoryArray.any? {|hash| hash.path == dir.path}
                            DirectoryRepository.new.delete(dir.id)
                            next
                        end

                        if dir.status != 'ignored'
                            dir.syncImages
                        end
                    end
                end
            end
        end
    end
end
