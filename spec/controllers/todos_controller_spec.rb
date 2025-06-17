require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  let(:valid_attributes) { { title: "Test Todo", done: false } }
  let(:invalid_attributes) { { title: "", done: false } }

  describe "GET #index" do
    it "assigns all todos as @todos" do
      todo = Todo.create!(valid_attributes)
      get :index
      expect(assigns(:todos)).to include(todo)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "assigns the requested todo as @todo" do
      todo = Todo.create!(valid_attributes)
      get :show, params: { id: todo.id }
      expect(assigns(:todo)).to eq(todo)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "assigns a new todo as @todo" do
      get :new
      expect(assigns(:todo)).to be_a_new(Todo)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "assigns the requested todo as @todo" do
      todo = Todo.create!(valid_attributes)
      get :edit, params: { id: todo.id }
      expect(assigns(:todo)).to eq(todo)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Todo" do
        expect {
          post :create, params: { todo: valid_attributes }, format: :html
        }.to change(Todo, :count).by(1)
      end

      it "redirects to todos_path with notice" do
        post :create, params: { todo: valid_attributes }, format: :html
        expect(response).to redirect_to(todos_path)
        expect(flash[:notice]).to eq('Todo was successfully created.')
      end

      it "responds to turbo_stream format" do
        post :create, params: { todo: valid_attributes }, format: :turbo_stream
        expect(response.media_type).to eq "text/vnd.turbo-stream.html"
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "does not create a new Todo" do
        expect {
          post :create, params: { todo: invalid_attributes }, format: :html
        }.not_to change(Todo, :count)
      end

      it "renders new template for HTML" do
        post :create, params: { todo: invalid_attributes }, format: :html
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end

      it "renders turbo_stream with form replacement" do
        post :create, params: { todo: invalid_attributes }, format: :turbo_stream
        expect(response.media_type).to eq "text/vnd.turbo-stream.html"
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:todo) { Todo.create!(valid_attributes) }

    it "destroys the requested todo" do
      expect {
        delete :destroy, params: { id: todo.id }, format: :html
      }.to change(Todo, :count).by(-1)
    end

    it "redirects to todos_path with notice" do
      delete :destroy, params: { id: todo.id }, format: :html
      expect(response).to redirect_to(todos_path)
      expect(flash[:notice]).to eq("Todo was successfully destroyed.")
    end

    it "responds with no content for JSON" do
      delete :destroy, params: { id: todo.id }, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "PATCH #toggle_done" do
    let!(:todo) { Todo.create!(valid_attributes) }

    it "toggles done status and redirects for HTML" do
      patch :toggle_done, params: { id: todo.id }, format: :html
      todo.reload
      expect(todo.done).to eq(!valid_attributes[:done])
      expect(response).to redirect_to(todos_path)
    end

    it "responds to turbo_stream format" do
      patch :toggle_done, params: { id: todo.id }, format: :turbo_stream
      expect(response.media_type).to eq "text/vnd.turbo-stream.html"
      expect(response).to have_http_status(:ok)
    end
  end
end
