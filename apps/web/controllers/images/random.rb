module Web
    module Controllers
        module Images
            class Random
                include Web::Action

                def call(params)
                    if params.to_h.key?(:today)
                        imageObject = ImageRepository.new.todayOrRandom(params[:orientation])
                    else
                        imageObject = ImageRepository.new.random(params[:orientation])
                    end

                    path = imageObject.path.gsub(' ', '\ ')

                    color = ' '
                    if params.to_h.key?(:gray) or params.to_h.key?(:grey) or params[:color] == 'gray'
                        color += '-colorspace gray '
                    end
                    orientation = ' -auto-orient '

                    crop = ' '
                    if params[:crop]
                        width = params[:crop].partition('x').first
                        height = params[:crop].partition('x').last

                        crop += '-resize ' + width + 'x' + height + '^ -gravity center -extent ' + width + 'x' + height
                    end

                    date = ' '
                    if params.to_h.key?(:date) and imageObject and imageObject.date_taken
                        date += "-fill white -pointsize 48 -undercolor '#0008' -gravity Southeast -draw 'text 0,-9 \"" +  imageObject.date_taken.strftime('%-m/%-d/%Y') + "\"'"
                    end

                    extension = path.reverse.partition('.').first.reverse.gsub(' ', '')
                    if params[:format] and params[:format] != 'bytes'
                        extension = params[:format]
                    end

                    destination = ' ./public/assets/converted.' + extension

                    command = 'convert ' + path + color + orientation + crop + date + destination

                    system(command)

                    if params[:format] and params[:format] == 'bytes'
                        system("python3 ./scripts/imgconvert.py -i " + destination + " -n pic -o ./public/assets/converted.h")
                        send_file("/assets/converted.h")
                    else
                        send_file(destination.partition('public').last)
                    end
                end
            end
        end
    end
end
