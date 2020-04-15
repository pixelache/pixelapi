CarrierWave.configure do |config|  
    config.storage = Rails.env.test? ? :file : :aws
    config.aws_credentials = {
      :access_key_id      => Rails.application.credentials.aws[:s3_access],
      :secret_access_key  => Rails.application.credentials.aws[:s3_secret],
      region: 'eu-west-1', # Required
      stub_responses:    Rails.env.test?
    }
    config.aws_acl    = :public_read
    config.asset_host = 
    config.aws_bucket  = "pixelache#{Rails.env.test? ? '' : '-' + Rails.env.to_s}"
    config.aws_attributes = -> { {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    } }

  # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end

