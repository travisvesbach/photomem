module Web
    module Controllers
        module Images
            class Subreddit
                include Web::Action

                def call(params)
                    url = "https://www.reddit.com/r/#{params[:sub] ? params[:sub] : 'art'}/top.json?sort=top&t=#{params[:time] ? params[:time] : 'day'}&limit=1"
                    data = JSON.parse(open(url, 'User-Agent' => 'thisisatestwoo').read)
                    imgUrl = data['data']['children'][0]['data']['url_overridden_by_dest']

                    downPath = './public/assets/down.png'

                    if ['jpeg', 'jpg', 'png'].include? imgUrl.split(".")[-1].downcase
                        Down.download(imgUrl, destination: downPath)
                        image = MiniMagick::Image.open(downPath)
                    elsif
                        image = MiniMagick::Image.open('./apps/web/assets/images/none-found.png')
                    end

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

                    image.write('./public/assets/converted.' + ext)
                    send_file('/assets/converted.' + ext)
                end
            end
        end
    end
end
