module Web
    module Controllers
        module Images
            class TodayOrRandom
                include Web::Action

                def call(params)
                    imageObject = ImageRepository.new.todayOrRandom(params[:orientation])
                    image = MiniMagick::Image.open(imageObject ? imageObject.path : './apps/web/assets/images/none-found.png')



                    if params[:color] == 'gray' or params[:mode] == 'gray'
                        image.colorspace("Gray")
                    end

                    image.auto_orient

                    if params[:crop]
                        width = params[:crop].partition('x').first.to_i
                        height = params[:crop].partition('x').last.to_i

                        w_original, h_original = [image[:width].to_f, image[:height].to_f]

                        o_size = nil
                        if width > height
                            o_size = "#{width}x"
                        else
                            o_size = "x#{height}"
                        end

                        image.combine_options do |c|
                          c.resize(o_size)
                          c.gravity(:center)
                          c.crop "#{width}x#{height}+0+0!"
                        end

                    elsif params[:size]
                        image.resize params[:size]
                    end

                    if params[:date] == 'true' and imageObject and imageObject.date_taken
                        image.combine_options do |c|
                            c.gravity 'Southeast'
                            c.fill 'white'
                            c.undercolor '#0008'
                            c.pointsize '48'
                            c.draw "text 0,-9 '" + imageObject.date_taken.strftime('%-m/%-d/%Y') + "'"
                        end
                    end

                    if params[:format] == 'h'
                        image.write('./public/assets/converted.png')
                        # result = `python3 ./scripts/imgconvert.py -i ./public/assets/converted.png -n pic -o ./public/assets/converted.h`
                        # result = system("python3 ./scripts/imgconvert.py -i ./public/assets/converted.png -n pic -o ./public/assets/converted.h")
                        data = IO.read("./public/assets/converted.h")

                        width = data.split("pic_width = ").last
                        width = width.split(";").first

                        height = data.split("pic_height = ").last
                        height = height.split(";").first

                        data = data.split("{").last
                        data = data.split("}").first
                        data = data.gsub(' ', '').gsub(/\t/, '')


                        self.format = :json

                        jsonData =  JSON.generate({
                            'pic_width' => width,
                            'pic_height' => height,
                            'pic_data' => data

                        })
                        # json(jsonData)
                        self.body = jsonData



                        puts jsonData
                        # Hanami.logger.debug("result----------------------")
                        # Hanami.logger.debug(result)
                        # abort



                    else
                        ext = params[:format] ? params[:format] : 'png'
                        image.write('./public/assets/converted.' + ext)
                        send_file('/assets/converted.' + ext)
                    end
                end
            end
        end
    end
end
