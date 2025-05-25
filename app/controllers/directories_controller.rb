class DirectoriesController < ApplicationController
  before_action :set_directory, only: [ :edit, :update, :destroy, :new_file, :create_file, :download ]

  # GET /directories
  def index
    @directories = Directory.where(parent_id: nil).includes(:subdirectories, :file_entries).order(:created_at)
  end

  # GET /directories/:id
  def show
    redirect_to directories_path
  end

  # GET /directories/new
  def new
    @directory = Directory.new(parent_id: params[:parent_id])
  end

  # POST /directories
  def create
    @directory = Directory.new(directory_params)
    if @directory.save
      redirect_to directories_path, notice: "Diretório criado com sucesso!"
    else
      render :new
    end
  end

  # GET /directories/:id/edit
  def edit
  end

  # PATCH/PUT /directories/:id
  def update
    @directory = Directory.find(params[:id])
    if @directory.update(directory_params)
      redirect_to directories_path, notice: "Diretório atualizado com sucesso!"
    else
      render :edit
    end
  end

  # DELETE /directories/:id
  def destroy
    @directory = Directory.find(params[:id])
    service = DirectoryDestroyerService.new(@directory)

    if service.confirmation? && !params[:confirm]
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
      service.destroy!
      respond_to do |format|
        format.json { render json: { message: "Diretório excluído com sucesso!" }, status: :ok }
        format.html do
          flash[:notice] = "Diretório excluído com sucesso!"
          redirect_to directories_path
        end
      end
    end
  end

  # GET /directories/:id/files
  def new_file
    @file_entry = @directory.file_entries.build
  end

  # POST /directories/:id/files
  def create_file
    @file_entry = @directory.file_entries.build(file_entry_params)
    if @file_entry.save
      redirect_to directory_path(@directory), notice: "Arquivo criado com sucesso!"
    else
      render :new_file, status: :unprocessable_entity
    end
  end

  # GET /directories/:id/download
  def download
    directory = Directory.find(params[:id])
    zip_data = ZipExporterService.new(directory).generate_zip

    send_data zip_data.read,
              filename: "#{@directory.name.parameterize}.zip",
              type: "application/zip"
  end

  private

  # Define o diretório atual com base no ID fornecido nos parâmetros
  def set_directory
    @directory = Directory.find(params[:id] || params[:directory_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Diretório não encontrado" }, status: :not_found
  end

  # Permite apenas os parâmetros permitidos para criar ou atualizar um diretório
  def directory_params
    params.require(:directory).permit(:name, :parent_id)
  end


  def file_entry_params
    params.require(:file_entry).permit(:name, :file)
  end
end
