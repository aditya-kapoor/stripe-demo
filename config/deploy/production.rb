set :stage, :production
set :rails_env, :production
set :branch, :master

server 'example.com', user: 'deploy', roles: %w{web app db}