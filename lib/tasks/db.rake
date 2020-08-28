require 'aws-sdk-s3'

namespace :db do
  desc 'Dumps the database to backups'
  task dump: :environment do
    dump_fmt   = ensure_format(ENV['format'])
    dump_sfx   = suffix_for_format(dump_fmt)
    backup_dir = backup_directory(Rails.env, create: true)
    full_path  = nil
    cmd        = nil

    with_config do |_app, host, port, db, user|
      full_path = "#{backup_dir}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{db}.#{dump_sfx}"
      cmd       = "pg_dump -F #{dump_fmt} -v -O -U '#{user}' -h '#{host}' -p '#{port}' -d '#{db}' -f '#{full_path}'"
    end

    system cmd
    upload_backup(full_path)
  end

  private

  def upload_backup(file)
    s3 = Aws::S3::Resource.new(
      access_key_id: ENV['STORAGE_KEY_ID'],
      secret_access_key: ENV['STORAGE_KEY_SECRET'],
      region: ENV['STORAGE_REGION'],
      endpoint: ENV['STORAGE_ENDPOINT']
    )
    prefix = 'backups_iume'
    name = File.basename(file)
    bucket = s3.bucket(ENV['STORAGE_DIRETORY'])
    obj = bucket.object("#{prefix}/#{name}")
    obj.upload_file(file)
    FileUtils.rm_f(file)
    data = bucket.objects(prefix: "#{prefix}/", delimiter: '').collect(&:key)
    data.each do |object|
        puts "#{object.key}\t#{object.last_modified}"
    end
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
    yield Rails.application.class.parent_name.underscore,
          ActiveRecord::Base.connection_config[:host],
          ActiveRecord::Base.connection_config[:port],
          ActiveRecord::Base.connection_config[:database],
          ActiveRecord::Base.connection_config[:username]
  end
end
