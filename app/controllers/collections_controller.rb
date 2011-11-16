class CollectionsController < ApplicationController
  load_and_authorize_resource

  def new
    @collection.collection_languages.build
    @collection.collection_countries.build
  end

  def create
    if @collection.save
      flash[:notice] = 'Collection was successfully created.'
      redirect_to @collection
    else
      render :action => 'new'
    end
  end

end
