# TODO: Write documentation for `Youtubecr`
require "kemal"
require "base64"

module Youtubecr
  VERSION = "0.1.0"

  # TODO: Put your code here
  get "/youtubecr" do |env|
    
    favicon = File.new("/var/www/domains/mischicanadas/subdomains/app/youtubecr/src/assets/img/favicon.png")
    favicon_enc = Base64.encode(favicon.gets_to_end)
    # favicon_plain = Base64.decode_string(favicon_enc)

    render "src/views/index.ecr" , "src/layouts/base.ecr"
  end

  post "/youtubecr/download" do |env|
    env.response.content_type = "application/json"

    url = env.params.json["url"].as(String)
    filename = env.params.json["filename"].as(String)
    file_type = env.params.json["file_type"].as(String)

    command = ""
    if file_type == "mp4"
      command = "youtube-dl -f 22 -o \"/var/www/domains/mischicanadas/subdomains/app/youtubecr/downloads/#{filename}.%(ext)s\" #{url}"
    end
    if file_type == "mp3"
      command = "youtube-dl --extract-audio --audio-format mp3 -o \"/var/www/domains/mischicanadas/subdomains/app/youtubecr/downloads/#{filename}.%(ext)s\" #{url}"
    end

    io = IO::Memory.new 
    Process.run(command, shell: true, output: io)
    io.to_s

  end

  get "/youtubecr/download/:filename" do |env|
    filename = env.params.url["filename"]
    send_file env, "/var/www/domains/mischicanadas/subdomains/app/youtubecr/downloads/#{filename}"
  end

end

Kemal.run(3014)