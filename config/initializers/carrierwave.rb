CarrierWave.configure do |config|
  config.fog_provider = 'fog/google'
  config.fog_credentials = {
    provider:                         'Google',
    google_storage_access_key_id:     ENV['GCS_ACCESS_KEY'],
    google_storage_secret_access_key: ENV['GCS_ACCESS_SECRET']
  }
  config.fog_directory = 'thorson-primeone'
end
