Rails.application.configure do
  config.active_storage.content_types_allowed_inline = %w[
    image/jpg
    image/jpeg
    image/png
  ]
  config.active_storage.content_types_to_serve_as_binary = %w[
    application/zip
    application/x-zip
    application/x-zip-compressed
  ]
end

Rails.application.config.to_prepare do
  #ActiveStorage::Blob.class_eval do
  #  def variant(variation)
  #    variation = ActiveStorage::Variation.wrap(variation)
  #    ActiveStorage::Variant.new(self, variation)
  #  end
  #end
end