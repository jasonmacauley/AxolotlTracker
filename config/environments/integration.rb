require 'socket'
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # ensure Rack redirects to "https" (if that protocol is specified in the X-SCHEME header)
  config.middleware.insert_before Warden::Manager, ProtocolEnforcer

  # issues #28 and #29 - suppression of certain exceptions
  config.middleware.use ExceptionFiltering

  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  config.assets.precompile += %w( ci5/dev_tools.css )

  # Use the ASSETS_HOSTS for a CDN if it is set
  if ENVIRON['ASSETS_HOST'].present?
    config.action_controller.asset_host = ['https://', ENVIRON['ASSETS_HOST']].join
  end

  # Generate digests for assets URLs
  config.assets.digest = true

  config.action_mailer.default_url_options = { host: 'quote-integration.simplybusiness.co.uk', port: nil }
  config.action_mailer.queued_settings = { delivery_method: :exact_target_multi }

  config.report_mailer_smtp_host = 'smtp-relay.gmail.com'

  # The roadie gem needs this to make URLs absolute
  config.roadie.url_options = config.action_mailer.default_url_options

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Redirect the customer if their JS is disabled
  config.js_redirect_enabled = true

  host = ENVIRON['DOMAIN_NAME'].present? ? ENVIRON['DOMAIN_NAME'] : SimplyBusiness.local_ip
  config.url_options = {
    protocol: 'https',
    host: host,
    port: nil
  }

  config.include_dev_tools = true
  config.persist_transactions = true

  config.force_ssl = true
  config.ssl_options = {
    redirect: {
      exclude: ->(request) { request.path =~ /^\/?(lb_health_check|assets|packs)/ }
    },
    hsts: {
      subdomains: false
    },
  }

  config.semafone_iframe_url = "https://#{host}/semafone_simulator"
  config.remove_lead_url     = "https://#{host}/backoffice"

  # In order for the application to recieve the client address any proxy
  # addresses must be stripped. Here we say that we trust the "current"
  # Cloudflare range and the NAT gateways for the walled garden. Anything else
  # is potentially the true client ip address.
  config.action_dispatch.trusted_proxies =
    ActionDispatch::RemoteIp::TRUSTED_PROXIES +
    %w(103.21.244.0/22 103.22.200.0/22 103.31.4.0/22 104.16.0.0/12
       108.162.192.0/18 131.0.72.0/22 141.101.64.0/18 162.158.0.0/15
       172.64.0.0/13 173.245.48.0/20 188.114.96.0/20 190.93.240.0/20
       197.234.240.0/22 198.41.128.0/17 34.243.169.55/32 34.250.194.43/32).map{
         |ip| IPAddr.new(ip)
  }
end
