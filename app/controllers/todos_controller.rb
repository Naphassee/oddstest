class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos or /todos.json
  def create
  @todo = Todo.new(todo_params)

  respond_to do |format|
    if @todo.save
      format.turbo_stream do
        # สมมติว่าเราต้องการ clear ฟอร์มหลังบันทึกสำเร็จ
        render turbo_stream: [
          turbo_stream.prepend('todos', partial: 'todos/todo', locals: { todo: @todo }),
          turbo_stream.replace('new_todo', partial: 'todos/form', locals: { todo: Todo.new }),
          turbo_stream.remove('no_quests')
        ]
      end
      format.html { redirect_to todos_path, notice: 'Todo was successfully created.' }
    else
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('new_todo', partial: 'todos/form', locals: { todo: @todo })
      end
      format.html { render :new }
    end
  end
  end


  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy!

    respond_to do |format|
      format.html { redirect_to todos_path, status: :see_other, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_done
    @todo = Todo.find(params[:id])
    @todo.update(done: !@todo.done)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "todo_#{@todo.id}",
          partial: "todos/todo",
          locals: { todo: @todo }
        )
      }
      format.html { redirect_to todos_path }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:title, :done)
    end
end
