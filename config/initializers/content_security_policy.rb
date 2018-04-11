# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |p|
  p.font_src    :self, :https, :data, 'http://cdn.jsdelivr.net/npm/hack-font@3/build/web/fonts/'
  p.img_src     :self, :https, :data
  p.object_src  :none
  p.style_src   :self, :https, :unsafe_inline, 'http://cdn.jsdelivr.net/npm/hack-font@3/build/web/hack.css'
  p.frame_src   :self, :https, 'https://js.stripe.com'

  if Rails.env.development?
    p.script_src :self, :https, :unsafe_inline, :unsafe_eval, 'https://js.stripe.com'
    p.default_src :self, :https, :unsafe_eval
    p.connect_src :self, :https, 'https://api.stripe.com', 'http://localhost:3035', 'ws://localhost:3035'
  else
    p.script_src :self, :https, :unsafe_inline, 'https://js.stripe.com'
    p.default_src :self, :https
    p.connect_src :self, :https, 'https://api.stripe.com'
  end

  # Specify URI for violation reports
  # p.report_uri "/csp-violation-report-endpoint"
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
