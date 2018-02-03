default[:gluons][:app_name]     = 'lampapp'

default[:gluons][:www_root]     = "/var/www"
default[:gluons][:app_root]     = "#{node[:gluons][:www_root]}/#{node[:gluons][:app_name]}"

default[:gluons][:app_source]  = "/vagrant/src/#{node[:gluons][:app_name]}"

default[:gluons][:shell_base]  = '/usr/local/bin'

# The path to the data_bag_key on the remote server
default[:gluons][:secretpath] = "/vagrant/src/secrets/data_bag_key"

# look for secret in file pointed to with gluons attribute :secretpath
data_bag_secret = Chef::EncryptedDataBagItem.load_secret("#{node[:gluons][:secretpath]}")

# Set domains from data_bag
domain_creds = Chef::EncryptedDataBagItem.load("envs", "domain", data_bag_secret)
if data_bag_secret && domain_envs = domain_creds[node.chef_environment]
  default[:gluons][:domain] = domain_envs['domain']
end

# Set MySQL info from data_bag
mysqlinfo_creds = Chef::EncryptedDataBagItem.load("envs", "mysql", data_bag_secret)
if data_bag_secret && mysql_envs = mysqlinfo_creds[node.chef_environment]
  default[:gluons][:db_name]      = mysql_envs['db_name']
  default[:gluons][:db_user]      = mysql_envs['db_user']
end
# Set MySQL passwords from data_bag
mysql_creds = Chef::EncryptedDataBagItem.load("passwords", "mysql", data_bag_secret)
if data_bag_secret && mysql_passwords = mysql_creds[node.chef_environment]
  default[:gluons][:db_password_root] = mysql_passwords['root']
  default[:gluons][:db_password] = mysql_passwords['app']
end

