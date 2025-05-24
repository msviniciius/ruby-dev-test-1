class DirectoriesController < ApplicationController
  before_action :set_directory, only: [:show, :edit, :update, :destroy, :new_file, :create_file]

  def index
    @directories = Directory.where(parent_id: nil).includes(:subdirectories, :file_entries).order(:created_at)
  end
  
  def show
    @directories = @directory
  end

  def new
    @directory = Directory.new(parent_id: params[:parent_id])
  end

  def create
    @directory = Directory.new(directory_params)
    if @directory.save
      redirect_to directories_path, notice: 'Diretório criado com sucesso!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @directory = Directory.find(params[:id])
    if @directory.update(directory_params)
      redirect_to directories_path, notice: 'Diretório atualizado com sucesso!'
    else
      render :edit
    end
  end

  def destroy
    sub_count = @directory.subdirectories.count
    if sub_count > 0
      redirect_to directories_path, alert: 'Não é possível excluir um diretório que contém subdiretórios.'
      render json: {
        confirm: true,
        message: 'Este diretório contém subdiretórios. Tem certeza que deseja excluí-lo?',
      }
    else
      @directory.destroy
      redirect_to directories_path, notice: 'Diretório excluído com sucesso!'
    end
  end

  def new_file
    @file_entry = @directory.file_entries.build
  end

  def create_file
    @file_entry = @directory.file_entries.build(file_entry_params)
    if @file_entry.save
      redirect_to directory_path(@directory), notice: 'Arquivo criado com sucesso!'
    else
      render :new_file, status: :unprocessable_entity
    end
  end

  private

  def set_directory
    @directory = Directory.find(params[:directory_id])
  end

  def directory_params
    params.require(:directory).permit(:name, :parent_id)
  end

  def file_entry_params
    params.require(:file_entry).permit(:name, :file)
  end
end