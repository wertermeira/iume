namespace :db do
  desc "TODO"
  task :dump => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_dump -F c -v -h #{host} -d #{db} -f #{Rails.root.join('tmp')}/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{db}"
    end
    puts cmd
    exec cmd
  end
  private

  def with_config
      yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end
end
