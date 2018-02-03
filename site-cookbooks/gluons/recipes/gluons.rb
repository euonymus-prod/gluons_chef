# Override the app.php files for gluons
template node[:gluons][:app_source] + '/config/app.php' do
  source 'app.php.erb'
  owner "www-data"
  group "www-data"
  mode "755"
  variables({
     :app_name      => node[:gluons][:app_name],
     :salt          => node[:gluons][:salt],
     :login         => node[:gluons][:db_user],
     :database      => node[:gluons][:db_name],
     :password      => node[:gluons][:db_password],
  })
end

# Change setting for text field by alter table
execute "init_subject_search" do
  command "mysql -S /var/run/mysql-" + node[:gluons][:app_name] + "/mysqld.sock -u" + node[:gluons][:db_user] + " -p" + node[:gluons][:db_password] + " " + node[:gluons][:db_name] + " -e'ALTER TABLE `subject_searches` MODIFY `search_words` TEXT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci` NOT NULL;'"
end
execute "init_ja_subject_search" do
  command "mysql -S /var/run/mysql-" + node[:gluons][:app_name] + "/mysqld.sock -u" + node[:gluons][:db_user] + " -p" + node[:gluons][:db_password] + " " + node[:gluons][:db_name] + " -e'ALTER TABLE `ja_subject_searches` MODIFY `search_words` TEXT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci` NOT NULL;'"
end

# make it myisam
execute "init_subject_search" do
  command "mysql -S /var/run/mysql-" + node[:gluons][:app_name] + "/mysqld.sock -u" + node[:gluons][:db_user] + " -p" + node[:gluons][:db_password] + " " + node[:gluons][:db_name] + " -e'ALTER TABLE `subject_searches` ENGINE = MyISAM;'"
end
execute "init_ja_subject_search" do
  command "mysql -S /var/run/mysql-" + node[:gluons][:app_name] + "/mysqld.sock -u" + node[:gluons][:db_user] + " -p" + node[:gluons][:db_password] + " " + node[:gluons][:db_name] + " -e'ALTER TABLE `ja_subject_searches` ENGINE = MyISAM;'"
end

