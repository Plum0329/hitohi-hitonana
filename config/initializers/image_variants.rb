Rails.application.config.after_initialize do
  #ActiveStorage::Blob.class_eval do
  #  def variant(transformations)
  #    variant_class = ActiveStorage.const_get(:Variant)
  #    variant_class.new(self, transformations)
  #  end
  #end
end