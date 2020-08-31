# Access to storage in aws
class AwsStorage
  attr_reader :prefix

  def initialize(prefix: 'backups_iume')
    @prefix = prefix
  end

  def bucket
    s3 = Aws::S3::Resource.new(credentials)
    s3.bucket(ENV['STORAGE_DIRETORY'])
  end

  private

  def credentials
    {
      access_key_id: ENV['STORAGE_KEY_ID'],
      secret_access_key: ENV['STORAGE_KEY_SECRET'],
      region: ENV['STORAGE_REGION'],
      endpoint: ENV['STORAGE_ENDPOINT']
    }
  end
end
