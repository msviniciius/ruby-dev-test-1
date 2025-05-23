class DirectoriesController < ApplicationController
  def index
    @directories = Directory.where(parent_id: nil).includes(:subdirectories, :file_entries)
  end
end