module Web
    module Controllers
        module Images
            class TodayOrRandom
                include Web::Action

                def call(params)
                    # url = "https://www.reddit.com/r/imaginarysliceoflife/top.json?sort=top&t=day&limit=1"
                    # data = JSON.parse(open(url, 'User-Agent' => 'thisisatestwoo').read)
                    # imgUrl = data['data']['children'][0]['data']['url_overridden_by_dest']

                    # downPath = './public/assets/down.png'

                    # Down.download(imgUrl, destination: downPath)


                    imageObject = ImageRepository.new.todayOrRandom

                    image = MiniMagick::Image.open(imageObject.path)


                    if params[:size]
                        image.resize(params[:size])
                    end

                    ext = params[:format] ? params[:format] : 'png'

                    if params[:color] == 'gray' or params[:mode] == 'gray'
                        image.colorspace("Gray")
                    end


                    if params[:date] == 'true' && imageObject.date_taken
                        image.combine_options do |c|
                            c.gravity 'Southeast'
                            c.fill 'white'
                            c.undercolor '#0008'
                            c.pointsize '24'
                            c.draw "text 0,-5 '" + imageObject.date_taken.strftime('%-m/%-d/%Y') + "'"
                        end
                    end

                    image.write('./public/assets/converted.' + ext)

                    send_file('/assets/converted.' + ext)
                end
            end
        end
    end
end