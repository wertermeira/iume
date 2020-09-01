namespace :db do
  desc 'Dumps the database to backups'
  task dump: :environment do
    dump_fmt   = ensure_format(ENV['format'])
    dump_sfx   = suffix_for_format(dump_fmt)
    backup_dir = backup_directory(Rails.env, create: true)
    full_path  = nil
    cmd        = nil

    with_config do |_app, host, port, db, user, pass|
      full_path = "#{backup_dir}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{db}.#{dump_sfx}"
      cmd = "PGPASSWORD='#{pass}' pg_dump -F #{dump_fmt} -v -O -U '#{user}' -h '#{host}' -p '#{port}' -d '#{db}' -f '#{full_path}'"
    end

    system cmd
    upload_backup(full_path)
  end

  desc 'Destroy old dumps'
  task destroy_old_dumps: :environment do
    prefix = AwsStorage.new.prefix
    bucket = AwsStorage.new.bucket
    data = bucket.objects(prefix: "#{prefix}/", delimiter: '').collect
    is_old = Time.now.utc - 15.days
    data.each do |object|
      next if object.last_modified >= is_old

      object.delete
    end
  end

  private

  def upload_backup(file)
    prefix = AwsStorage.new.prefix
    name = File.basename(file)
    bucket = AwsStorage.new.bucket
    obj = bucket.object("#{prefix}/#{name}")
    FileUtils.rm_f(file) if obj.upload_file(file)
  end

  def ensure_format(format)
    return format if %w[c p t d].include?(format)

    case format
    when 'dump' then 'c'
    when 'sql' then 'p'
    when 'tar' then 't'
    when 'dir' then 'd'
    else 'p'
    end
  end

  def suffix_for_format(suffix)
    case suffix
    when 'c' then 'dump'
    when 'p' then 'sql'
    when 't' then 'tar'
    when 'd' then 'dir'
    end
  end

  def format_for_file(file)
    case file
    when /\.dump$/ then 'c'
    when /\.sql$/  then 'p'
    when /\.dir$/  then 'd'
    when /\.tar$/  then 't'
    end
  end

  def backup_directory(suffix = nil, create: false)
    backup_dir = File.join(*[Rails.root, 'tmp/backups', suffix].compact)

    if create && !Dir.exist?(backup_dir)
      puts "Creating #{backup_dir} .."
      FileUtils.mkdir_p(backup_dir)
    end

    backup_dir
  end

  def with_config
    return credentails_production if Rails.env.production?

    yield Rails.application.class.parent_name.underscore,
          ActiveRecord::Base.connection_config[:host],
          ActiveRecord::Base.connection_config[:port],
          ActiveRecord::Base.connection_config[:database],
          ActiveRecord::Base.connection_config[:username],
          ActiveRecord::Base.connection_config[:password]
  end

  def credentails_production
    yield Rails.application.class.parent_name.underscore,
          database_credentials.dig(:host),
          database_credentials.dig(:port),
          database_credentials.dig(:database),
          database_credentials.dig(:user),
          database_credentials.dig(:password)
  end

  def database_credentials
    DatabaseUrl.to_active_record_hash(ENV['DATABASE_URL'])
  end
end
