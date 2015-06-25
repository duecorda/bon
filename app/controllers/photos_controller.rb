class PhotosController < ApplicationController

  before_filter :login_required, except: [:index, :show]

  def index
    @photos = Photo.order("id desc")
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def crop
    @photo = Photo.find(params[:id])

    x = params[:x]
    y = params[:y]
    w = params[:w]
    h = params[:h]

    %x(convert #{@photo.path(:thumb)} -crop #{w}x#{h}+#{x}+#{y} #{@photo.path(:crop)})

    redirect_to photo_path(@photo)
  end

  def mosaic
    @photo = Photo.find(params[:id])

    x = params[:x]
    y = params[:y]
    w = params[:w]
    h = params[:h]

    %x(convert #{@photo.path(:thumb)} -size #{w}x#{h} -draw 'rectangle 10,10 10,10'  #{@photo.path(:mosaic)})
    redirect_to photo_path(@photo)
  end

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

  def fetch
    @photo = Photo.new(attachment: params[:photo_url], user_id: @current_user.id)
    if @photo.save
      @photos = [@photo]
    end
    render :layout => false
  end

  def search
    q = params[:keyword].blank? ? "*" : params[:keyword].split(/\s+/).collect {|x| "*#{x}*"}.join(" AND ")
    @photos = Photo.search(q).per(5).page(params[:page]).records
    render :layout => false
  end

end
