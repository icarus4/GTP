if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # required
      region:                'ap-northeast-1',                  # optional, defaults to 'us-east-1'
      # host:                  's3.example.com',             # optional, defaults to nil
      # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = 'icarus4-gtp'                          # required
    config.fog_public     = true                                        # optional, defaults to true
    # config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
  end
end
