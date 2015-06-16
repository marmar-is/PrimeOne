class PoliciesController < ApplicationController
  before_action :set_policy, only: [:show, :edit, :update, :destroy]

  # GET /policies
  # GET /policies.json
  def index
    @policies = Policy.all
  end

  # GET /policies/1
  # GET /policies/1.json
  def show
    @title = @policy.policy_number
    #@countersign = (@policy.B+1.month).to_time.ish(offset: 10.days).to_date.strftime("%_m/%d/%Y")

  end

  # GET /policies/new
  def new
    @policy = Policy.new
  end

  # GET /policies/1/edit
  def edit
  end

  # POST /policies
  # POST /policies.json
  def create
    @policy = Policy.new(policy_params)

    respond_to do |format|
      if @policy.save
        format.html { redirect_to @policy, notice: 'Policy was successfully created.' }
        format.json { render :show, status: :created, location: @policy }
      else
        format.html { render :new }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /policies/1
  # PATCH/PUT /policies/1.json
  def update
    respond_to do |format|
      if @policy.update(policy_params)
        format.html { redirect_to @policy, notice: 'Policy was successfully updated.' }
        format.json { render :show, status: :ok, location: @policy }
      else
        format.html { render :edit }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /policies/1
  # DELETE /policies/1.json
  def destroy
    @policy.destroy
    respond_to do |format|
      format.html { redirect_to policies_url, notice: 'Policy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def find
    @policy = Policy.find_by_policy_number(params[:policy_number])

    if @policy != nil
      redirect_to policy_path(@policy)
    else
      redirect_to policies_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy
      @policy = Policy.find(params[:id])
      @broker = @policy.broker
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_params
      params.require(:policy).permit(:number, :status, :code, :name, :effective,
      :broker_id, :forms, :property_forms, :gl_forms, :crime_forms, :auto_forms,
      :expiry, :org, :dba, :biztype, :street, :city, :state, :zip, :total_premium
      )
    end
end
