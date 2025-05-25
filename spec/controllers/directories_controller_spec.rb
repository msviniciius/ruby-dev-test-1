require 'rails_helper'

RSpec.describe DirectoriesController, type: :controller do
  include ActionDispatch::TestProcess::FixtureFile

  let!(:root_directory) { create(:directory) }
  let(:valid_attributes) { { name: "Novo Diretório", parent_id: nil } }
  let(:invalid_attributes) { { name: "" } }

  describe "GET /index" do
    it "retorna a lista de diretórios raiz com sucesso" do
      get :index
      expect(response).to be_successful
      expect(assigns(:directories)).to include(root_directory)
    end
  end

  describe "GET /new" do
    it "inicia a criação de um novo diretório com parend_id" do
      get :new, params: { parent_id: root_directory.id }
      expect(assigns(:directory)).to be_a_new(Directory)
      expect(assigns(:directory).parent_id).to eq(root_directory.id)
    end
  end

  describe "POST /create" do
    context "com atributos válidos" do
      it "cria um novo diretório e redireciona" do
        expect {
          post :create, params: { directory: valid_attributes }
        }.to change(Directory, :count).by(1)

        expect(response).to redirect_to(directories_path)
        expect(flash[:notice]).to eq("Diretório criado com sucesso!")
      end
    end

    context "com atributos inválidos" do
      it "rederiza a view de novo diretório" do
        post :create, params: { directory: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /edit" do
    it "carrega o diretório para edição" do
      get :edit, params: { id: root_directory.id }
      expect(assigns(:directory)).to eq(root_directory)
    end
  end

  describe "PATCH /update" do
    it "atualiza o diretório e redireciona" do
      patch :update, params: { id: root_directory.id, directory: { name: "Nome alterado" } }
      expect(response).to redirect_to(directories_path)
      expect(flash[:notice]).to eq("Diretório atualizado com sucesso!")
      expect(root_directory.reload.name).to eq("Nome alterado")
    end
  end

  describe "DELETE /destroy" do
    context "sem subdiretórios ou arquivos" do
      it "exclui o diretorio" do
        expect {
          delete :destroy, params: { id: root_directory.id }
        }.to change(Directory, :count).by(-1)


        expect(response).to redirect_to(directories_path)
        expect(flash[:notice]).to eq("Diretório excluído com sucesso!")
      end
    end

    context "com subdiretórios ou arquivos e sem confirmação" do
      let!(:diretorio_with_files) { create(:directory, :with_files) }

      it "retorna mensagem de confirmação HTML" do
        delete :destroy, params: { id: diretorio_with_files.id }
        expect(response).to redirect_to(directories_path)
        expect(flash[:alert]).to match(/contém arquivos ou subdiretórios/)
      end

      it "retorna mensagem de confirmação JSON" do
        delete :destroy, params: { id: diretorio_with_files.id }, format: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("confirm" => true)
      end
    end
  end

  describe "GET /new_file" do
    it "inicializa um novo arquivo para o diretório" do
      get :new_file, params: { directory_id: root_directory.id }
      expect(assigns(:file_entry)).to be_a_new(FileEntry)
    end
  end

  describe "POST /create_file" do
    let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/test.txt'), 'text/plain') }

    it "cria um arquivo no diretório" do
      expect {
        post :create_file, params: {
          directory_id: root_directory.id,
          file_entry: { name: "Teste", file: file }
        }
      }.to change(FileEntry, :count).by(1)
    end
  end
end
