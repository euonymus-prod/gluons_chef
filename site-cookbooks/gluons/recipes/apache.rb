# settings for vhost
directory(node[:gluons][:www_root])

# override apache config here
web_app(node[:gluons][:app_name]) do
  server_name(node[:gluons][:domain])
  docroot(node[:gluons][:app_root])
  template('vhost.conf.erb')
end
