require 'zip'

class DirectoriesController < ApplicationController
  before_action :set_directory, only: [ :edit, :update, :destroy, :new_file, :create_file, :download]

  def index
    @directories = Directory.where(parent_id: nil).includes(:subdirectories, :file_entries).order(:created_at)
  end

  def show
    redirect_to directories_path
  end

  def new
    @directory = Directory.new(parent_id: params[:parent_id])
  end

  def create
    @directory = Directory.new(directory_params)
    if @directory.save
      redirect_to directories_path, notice: "Diretório criado com sucesso!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @directory = Directory.find(params[:id])
    if @directory.update(directory_params)
      redirect_to directories_path, notice: "Diretório atualizado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    if (@directory.subdirectories.any? || @directory.file_entries.any?) && !params[:confirm]
      respond_to do |format|
        format.json do
          render json: {
            confirm: true,
            message: "Este diretório contém arquivos ou subdiretórios. Você tem certeza que deseja excluí-lo?"
          }, status: :ok
        end
        format.html do
          flash[:alert] = "Este diretório contém arquivos ou subdiretórios. Você tem certeza que deseja excluí-lo?"
          redirect_to directories_path
        end
      end
    else
      @directory.destroy
      respond_to do |format|
        format.json { render json: { message: "Diretório excluído com sucesso!" }, status: :ok }
        format.html do
          flash[:notice] = "Diretório excluído com sucesso!"
          redirect_to directories_path
        end
      end
    end
  end

  def new_file
    @file_entry = @directory.file_entries.build
  end

  def create_file
    @file_entry = @directory.file_entries.build(file_entry_params)
    if @file_entry.save
      redirect_to directory_path(@directory), notice: "Arquivo criado com sucesso!"
    else
      render :new_file, status: :unprocessable_entity
    end
  end

  def download
    temp = Tempfile.new(["directory-#{@directory.id}", '.zip']) # criando o arquivo zip inicialmente vazio

    begin
      Zip::OutputStream.open(temp) { |z| }

      Zip::File.open(temp.path, Zip::File::CREATE) do |zipfile|
        add_directory_to_zip(@directory, zipfile)
      end

      send_data File.read(temp.path),
                fype: 'application/zip',
                filename: "#{@directory.name.parameterize}.zip"
      
    ensure
      temp.close
      temp.unlink
    end
  end

  private

  def set_directory
    @directory = Directory.find(params[:id] || params[:directory_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Diretório não encontrado" }, status: :not_found
  end

  def directory_params
    params.require(:directory).permit(:name, :parent_id)
  end

  def file_entry_params
    params.require(:file_entry).permit(:name, :file)
  end

  def add_directory_to_zip(directory, zipfile, path_prefix = "")
    current_path = path_prefix.present? ? "#{path_prefix}/#{directory.name}" : directory.name

    # adiciona os arquivos deste diretório
    directory.file_entries.each do |file_entry|
      if file_entry.file.attached?
        file_path_in_zip = "#{current_path}/#{file_entry.name}"
        zipfile.get_output_stream(file_path_in_zip) do |f|
          f.write file_entry.file.download
        end
      end
    end

    # de forma recursiva é adicionado os subdiretórios
    directory.subdirectories.each do |sub|
      add_directory_to_zip(sub, zipfile, current_path)
    end
  end
end
