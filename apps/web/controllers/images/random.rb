module Web
    module Controllers
        module Images
            class Random
                include Web::Action

                def call(params)
                    imageObject = ImageRepository.new.random(params[:orientation])
                    image = MiniMagick::Image.open(imageObject ? imageObject.path : './apps/web/assets/images/none-found.png')

                    ext = params[:format] ? params[:format] : 'png'

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

                    image.write('./public/assets/converted.' + ext)
                    send_file('/assets/converted.' + ext)
                end
            end
        end
    end
end
