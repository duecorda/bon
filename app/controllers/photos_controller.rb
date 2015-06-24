class PhotosController < ApplicationController

  before_filter :login_required, except: [:index, :show]

  def create
    res = {:files => []}

    params[:photo][:attachment].each do |attachment|

      @photo = Photo.new(attachment: attachment, user_id: @current_user.id)
      if @photo.save
        res[:files].push({
          :name => @photo.original_filename,
          :url => @photo.url(:thumb)
        })
      end
    end

    render :content_type => request.format, :json => res.to_json
  end

  def search
    q = params[:keyword].blank? ? "*" : params[:keyword].split(/\s+/).collect {|x| "*#{x}*"}.join(" AND ")
    @photos = Photo.search(q).per(5).page(params[:page]).records
    render :layout => false
  end

end
