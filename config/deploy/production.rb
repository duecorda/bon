set :db_user, 'bon'
set :db_password, 'bon123!'

server '128.199.156.207', user: 'cm', roles: %w{web app db}
