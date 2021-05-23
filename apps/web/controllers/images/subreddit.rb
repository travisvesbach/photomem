module Web
    module Controllers
        module Images
            class Subreddit
                include Web::Action

                def call(params)
                    url = "https://www.reddit.com/r/#{params[:sub] ? params[:sub] : 'art'}/top.json?sort=top&t=#{params[:time] ? params[:time] : 'day'}&limit=1"
                    data = JSON.parse(open(url, 'User-Agent' => 'thisisatestwoo').read)
                    img_url = data['data']['children'][0]['data']['url_overridden_by_dest']

                    path = './public/assets/down.png'
                    if ['jpeg', 'jpg', 'png'].include? img_url.split(".")[-1].downcase
                        Down.download(img_url, destination: path)
                    else
                        path = './apps/web/assets/images/none-found.png'
                    end

                    color = ' '
                    if params.to_h.key?(:gray) or params.to_h.key?(:grey) or params[:color] == 'gray'
                        color += '-colorspace gray'
                    end

                    crop = ' '
                    if params[:crop]
                        width = params[:crop].partition('x').first
                        height = params[:crop].partition('x').last

                        crop += '-resize ' + width + 'x' + height + '^ -gravity center -extent ' + width + 'x' + height
                    end

                    extension = path.reverse.partition('.').first.reverse.gsub(' ', '')
                    if params[:format] and params[:format] != 'bytes'
                        extension = params[:format]
                    end

                    destination = ' ./public/assets/converted.' + extension

                    command = 'convert ' + path + color + crop + destination
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
