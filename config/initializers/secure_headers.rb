SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w(origin-when-cross-origin strict-origin-when-cross-origin)

  config.csp = {
    default_src: %w('self'),
    script_src: %w('self'),
    style_src: %w('self'),
    img_src: %w('self' data: *.cloudinary.com res.cloudinary.com),
    connect_src: %w('self'),
    font_src: %w('self'),
    object_src: %w('none'),
    frame_ancestors: %w('none'),
    form_action: %w('self'),
    base_uri: %w('self'),
    manifest_src: %w('self')
  }
end