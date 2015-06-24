class EmbedsController < ApplicationController

  def create
    begin
      @embed = Embed.new(source: params[:source])
    rescue Embed::EmbedError => e
      @msg = e.message
      render template: "/main/error" and return
    end

    @embed.save
  end

  def search
    q = params[:keyword].blank? ? "*" : params[:keyword].split(/\s+/).collect {|x| "*#{x}*"}.join(" AND ")
    @embeds = Embed.search(q).per(5).page(params[:page]).records
    render :layout => false
  end

end
