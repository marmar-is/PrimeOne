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
    #if user_signed_in? || params[:tok] == "WICKED_PDF"
    @countersign = (@policy.effective+1.month).to_time.ish(offset: 10.days).to_date.strftime("%_m/%d/%Y")
    render :pdf, layout: 'pdf.html.erb'
    #else
    #  redirect_to new_user_session_path
    #end
  end

  # Determine which forms should be downloaded
  # GET /policies/1/generate
  def generate
    @countersign = (@policy.effective+1.month).to_time.ish(offset: 10.days).to_date.strftime("%_m/%d/%Y")
    html = render_to_string(action: :pdf, layout: "layouts/pdf.html.erb")
    pdf = WickedPdf.new.pdf_from_string(html)

    File.open("private/temp_pdf/dec_temp.pdf", 'wb') do |f|
      f << pdf
    end

    @pdfForms = CombinePDF.new
    @pdfForms << CombinePDF.load("private/temp_pdf/dec_temp.pdf")

    form_groups = [:forms, :property_forms, :gl_forms, :crime_forms, :auto_forms]

    all_fills = [ "CG1218(6-95).pdf", "CG2011(1-96).pdf", "CG2018(11-85).pdf",
      "CG2026(7-04).pdf", "CG2028(7-04).pdf", "CG2144(7-98).pdf",
      "CP0440(6-95).pdf", "IL0415(4-98).pdf" ]

    active_fills = []

    form_groups.each do |fg|
      if !@policy[fg].empty?
        @policy[fg].split(" ").each do |f|
          f = f.gsub("/", "-")

          if !all_fills.include?("#{f}.pdf")
            begin
              open('private/temp_pdf/temp.pdf', 'wb') do |file|
                file << open("http://storage.googleapis.com/endorsements/Static/#{f}.pdf").read
                #file << open("private/forms/#{f}.pdf").read
              end
              @pdfForms << CombinePDF.load("private/temp_pdf/temp.pdf")
            rescue
            end
          else
            active_fills << "#{f}.pdf"
          end
        end
      end
    end

    active_fills.each do |f|
      begin
        open('private/temp_pdf/temp.pdf', 'wb') do |file|
          file << open("http://storage.googleapis.com/endorsements/Static/#{f}").read
          #file << open("private/forms/#{f}.pdf").read
        end
        @pdfForms << CombinePDF.load("private/temp_pdf/temp.pdf")
      rescue
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

    # Find the forms necessary for this policy
    def findForms
      if !@policy.forms.include?('IL0003(9/08) IL0017(11/98) IL0286(9/08) IL0030(1/06) IL0031(1/06) ')
        @policy.forms += 'IL0003(9/08) IL0017(11/98) IL0286(9/08) IL0030(1/06) IL0031(1/06) '
      end

      # property
      if @policy.property.total.to_i != 0 && !@policy.property_forms.include?("CP0010(6/07) CP0090(7/88) CP0120(1/08) CP0140(7/06) CP1032(8/08) IL0935(7/02) IL0953(1/08) CP1270(9/96) ")
        @policy.property_forms +=  "CP0010(6/07) CP0090(7/88) CP0120(1/08) CP0140(7/06) CP1032(8/08) IL0935(7/02) IL0953(1/08) CP1270(9/96) "
      end

      if @policy.locations.first.limit_earnings.to_i != 0 && !@policy.property_forms.include?("CP0030(6/07) ")
        @policy.property_forms +=  "CP0030(6/07) "
      end

      if @policy.locations.first.spoilage.to_i != 0 && !@policy.property_forms.include?("CP0440(6/95) ")
        @policy.property_forms +=  "CP0440(6/95) "
      end

      if @policy.locations.first.loss_coverage.downcase == "basic" && !@policy.property_forms.include?("CP1010(6/07) ")
        @policy.property_forms +=  "CP1010(6/07) "
      elsif @policy.locations.first.loss_coverage.downcase == "broad" && !@policy.property_forms.include?("CP1020(6/07) ")
        @policy.property_forms +=  "CP1020(6/07) "
      elsif @policy.locations.first.loss_coverage.downcase == "special" && !@policy.property_forms.include?("CP1030(6/07) ")
        @policy.property_forms +=  "CP1030(6/07) "
      end

      if @policy.locations.first.limits_sign.to_i != 0 && !@policy.property_forms.include?("CP1440(6/07) ")
        @policy.property_forms +=  "CP1440(6/07) "
      end

      if @policy.locations.first.enhancement.to_i != 0 && !@policy.property_forms.include?("PO-PRP-3(12/13) ")
        @policy.property_forms +=  "PO-PRP-3(12/13) "
      end

      # crime
      if @policy.crime.total.to_i != 0 && !@policy.crime_forms.include?("CR0021(5/06) CR0110(8/07) CR0246(8/07) CR0730(3/06) CR0731(3/06) IL0935(7/02) IL0953(1/08) ")
        @policy.crime_forms +=  "CR0021(5/06) CR0110(8/07) CR0246(8/07) CR0730(3/06) CR0731(3/06) IL0935(7/02) IL0953(1/08) "
      end

      if @policy.crime.limit_theft.to_i != 0 && !@policy.crime_forms.include?("CR0029(5/06) ")
        @policy.crime_forms +=  "CR0029(5/06) "
      end

      if @policy.crime.limit_money.to_i != 0 && !@policy.crime_forms.include?("CR0405(8/07) ")
        @policy.crime_forms +=  "CR0405(8/07) "
      end

      if @policy.crime.limit_safe_burglary.to_i != 0 && !@policy.crime_forms.include?("CR0405(8/07) ")
        @policy.crime_forms +=  "CR0405(8/07) "
      end

      if @policy.crime.limit_safe_burglary.to_i != 0 && !@policy.crime_forms.include?("PO-CR-1(10/10) ")
        @policy.crime_forms +=  "PO-CR-1(10/10) "
      end

      if @policy.crime.limit_safe_burglary.to_i != 0 && !@policy.crime_forms.include?("CR3510(8/07) ")
        @policy.crime_forms +=  "CR3510(8/07) "
      end

      if @policy.crime.limit_premises_burglary.to_i != 0 && !@policy.crime_forms.include?("CR3532(8/07) ")
        @policy.crime_forms +=  "CR3532(8/07) "
      end

      if @policy.crime.limit_premises_burglary.to_i != 0 && !@policy.crime_forms.include?("CR0407(8/07) ")
        @policy.crime_forms +=  "CR0407(8/07) "
      end

      # general liability
      if @policy.gl.total.to_i != 0 && !@policy.gl_forms.include?("CG0001(12/07) CG0068(5/09) CG0099(11/85) CG0168(12/4) CG2101(11/85) CG2146(7/98) CG2147(12/07) CG2149(9/99) CG2167(12/04) CG2175(6/08) CG2190(1/06) CG2231(7/98) CG2258(11/85) CG2407(1/96) IL0021(9/08) PO-PRP-GL-1(8/13) PO-GL-5(5/12) PO-GL-6(5/12) ")
        @policy.gl_forms +=  "CG0001(12/07) CG0068(5/09) CG0099(11/85) CG0168(12/4) CG2101(11/85) CG2146(7/98) CG2147(12/07) CG2149(9/99) CG2167(12/04) CG2175(6/08) CG2190(1/06) CG2231(7/98) CG2258(11/85) CG2407(1/96) IL0021(9/08) PO-PRP-GL-1(8/13) PO-GL-5(5/12) PO-GL-6(5/12) "
      end

      #if @policy.EA != "$-" && @policy.EA != "-" && @policy.EA != "0" && @policy.EA != "$0.00" && !@policy.EA.blank? &&
      #  !@policy.gl_forms.include?("PL-GL-WIG(12/13) ")
      #  @policy.gl_forms +=  "PL-GL-WIG(12/13) "
      #end

      # auto
      if @policy.auto.total != 0 && !@policy.auto_forms.include?("CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) ")
        @policy.auto_forms +=  "CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) "
      end

      @policy.save
    end
end
