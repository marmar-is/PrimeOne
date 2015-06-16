class PoliciesController < ApplicationController
  before_action :set_policy, only: [:show, :edit, :update, :destroy, :pdf, :generate, :update_forms, :populate]

  # GET /policies
  # GET /policies.json
  def index
    @policies = Policy.all
  end

  # GET /policies/1
  # GET /policies/1.json
  def show
    @title = @policy.number

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
    @policy = Policy.find_by_number(params[:number].upcase)

    if @policy != nil
      redirect_to policy_path(@policy)
    else
      redirect_to policies_path
    end
  end

  def pdf
    if user_signed_in? || params[:tok] == "WICKED_PDF"
      @countersign = (@policy.effective+1.month).to_time.ish(offset: 10.days).to_date.strftime("%_m/%d/%Y")
      render :pdf, layout: 'pdf.html.erb'
    else
      redirect_to new_user_session_path
    end
  end

  # Determine which forms should be downloaded
  # GET /policies/1/generate
  def generate
    html = render_to_string(action: :pdf, layout: "layouts/pdf.html.erb")
    pdf = WickedPdf.new.pdf_from_string(html)

    File.open("private/temp_pdf/dec_temp.pdf", 'wb') do |f|
      f << pdf
    end

    @pdfForms = CombinePDF.new
    @pdfForms << CombinePDF.load("private/temp_pdf/dec_temp.pdf")

    form_groups = [:forms, :property_forms, :gl_forms, :crime_forms, :auto_forms]

    form_groups.each do |fg|
      if !@policy[fg].empty?
        @policy[fg].split(" ").each do |f|
          f = f.gsub("/", "-")
          begin
            open('private/temp_pdf/temp.pdf', 'wb') do |file|
              #file << open("http://storage.googleapis.com/endorsements/#{f}.pdf").read
              file << open("private/forms/#{f}.pdf").read
            end
            @pdfForms << CombinePDF.load("private/temp_pdf/temp.pdf")
          rescue
          end
        end
      end
    end

    send_data @pdfForms.to_pdf, filename: "Policy_#{@policy.number}.pdf", disposition: 'inline', format: 'pdf'
  end

  def update_forms
    @policy = Policy.find(params[:id])

    if (@policy[params[:group]].include?(params[:forms]))
      @policy[params[:group]].slice!(params[:forms])
    else
      @policy[params[:group]] += params[:forms]
    end

    respond_to do |format|
      @policy.save

      format.html { render :show }
      format.js { render :show }
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
