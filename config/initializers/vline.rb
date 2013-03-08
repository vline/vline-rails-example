require 'vline'

Vline.setup do |config|

  config.app_id = 'vlinetest'
  config.provider_id = 'vlinetest'
  config.client_id = 'aGG6wizg31HDIbfhzOeSc5JzV1qmgZwBWU4qKgxulUY'
  config.client_secret = 'V8kCAeC2ekt4VrRnnkkxNn-8r8RwQSc1IxpREA1x3VQ'

  # NOTE: replace this with a secret (i.e., not checked into vcs) value in production!!
  config.provider_secret = 'JIm_h_wUHdBIPDaRK5LTwgmxNRMwXmCz9v45RYdeXxo'
end
