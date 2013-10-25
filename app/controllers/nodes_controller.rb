class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  # GET /nodes
  # GET /nodes.json
  def index
    @characters = Character.all.includes(:nodes)
    @nodes_by_id = Node.hash_by(:id)
    @nodes = Node.all.includes(:characters)
    
    # TODO TODO TODO ! Each level of updated_at must take in account the inferior level
    # Exemple : characters_updated_at must be the max between every character.updated_at AND
    # every node.updated_at AND every topic.updated_at
    # The character.updated_at must also be the max of nodes.updated_at, ...
    # Method : Make that node update updated_at of the character after updated itself
    @characters_updated_at = @characters.maximum(:updated_at)
    
    @characters_by_id = Character.hash_by(:id)
    #@nodes_by_begin_at = Node.hash_by(:begin_at)
    respond_to do |format|
      format.html
      format.json do
        render :json => {
          :characters => @characters.map(&:json_attributes),
          :characters_updated_at => @characters_updated_at,
          :nodes_by_id => @nodes_by_id
        }
      end
    end
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
  end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(node_params)

    respond_to do |format|
      if @node.save
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render action: 'show', status: :created, location: @node }
      else
        format.html { render action: 'new' }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    respond_to do |format|
      if @node.update(node_params)
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to nodes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def node_params
      params.require(:node).permit(:longitude, :latitude, :title, 
        :resume, :topic_id, :begin_at, :end_at, :character_ids => [])
    end
end
