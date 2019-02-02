module ImageUploadActions
  def upload_image
    url = ImageUploader.new(params[:file], uploader_options).execute
    if url
      render json: { url: url }
    else
      render json: { error: 'Invalid file' }
    end
  end

  private

  def uploader_options
    raiser NotImprementedError
  end
end
