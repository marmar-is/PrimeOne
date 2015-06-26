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
        #format.html { redirect_to policy_path(@policy), notice: 'Policy was successfully updated.' }
        format.html { render :show, notice: 'Policy was successfully updated.' }
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

  # go to the designated policy
  def find
    @policy = Policy.find_by_number(params[:number].upcase)

    if @policy != nil
      redirect_to policy_path(@policy)
    else
      redirect_to policies_path
    end
  end

  def pdf
    @countersign = (@policy.effective+1.month).to_time.ish(offset: 10.days).to_date.strftime("%_m/%d/%Y")
    render :pdf, layout: 'pdf.html.erb'
  end

  def review
    @policies = Policy.where("status=? OR status=?", "GENERATED", "ERRING")
  end

  def fillForm
    #json = "[{
    #  \"LOSS PAYABLE\":\"ppk0001000\"
    #}]"
    json = "A\nPPK"
    open('private/fillable/input.csv', 'wb') do |f|
      f << json
    end
    #{}`curl https://pdfprocess.datalogics.com/api/actions/fill/form --insecure --form 'application={"id": "50b3c3f6", "key": "0c6061fd77d7c26c640ca99331f44897"}' --form input=@private/fillable/CG1218_6-95.pdf --form filename=@input.json --output flattened.pdf`

    f = "CG1218_6-95.pdf"
    #x = %x[ curl https://pdfprocess.datalogics.com/api/actions/flatten/form --insecure --form 'application={"id": "50b3c3f6", "key": "0c6061fd77d7c26c640ca99331f44897"}' --form input=@private/fillable/#{f} ]
    x = %x[ curl https://pdfprocess.datalogics.com/api/actions/fill/form --insecure --form 'application={"id": "50b3c3f6", "key": "0c6061fd77d7c26c640ca99331f44897"}' --form input=@private/fillable/#{f} --form formsData=@private/fillable/input.csv --output private/fillable/out.pdf ]

    #send_data x, filename: "Test.pdf", format: 'pdf'
    #x = %x[ curl https://pdfprocess.datalogics.com/api/actions/export/form-data --insecure --form 'application={"id": "50b3c3f6", "key": "0c6061fd77d7c26c640ca99331f44897"}' --form input=@private/fillable/#{f} ]
    puts x
    #request = ActionDispatch::Request.new(Rails.env)
    #puts request
    redirect_to policy_path(Policy.find(4))
    #x = NET::HTTP.post_form()
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

    all_fills = [ "CP1218(6-95).pdf", "CG2011(1-96).pdf", "CG2018(11-85).pdf",
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

    open("generated/Policy_#{@policy.number}_(#{@policy.dba || @policy.name}).pdf", 'wb') do |f|
      f << @pdfForms.to_pdf
    end

    #redirect_to @policy
    send_data @pdfForms.to_pdf, filename: "Policy_#{@policy.number}_(#{@policy.dba || @policy.name}).pdf", disposition: 'inline', format: 'pdf'
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
      if !p.forms.include?('IL0003(9/08) IL0017(11/98) IL0286(9/08) IL0030(1/06) IL0031(1/06) ')
        p.forms += 'IL0003(9/08) IL0017(11/98) IL0286(9/08) IL0030(1/06) IL0031(1/06) '
      end

      # property
      if p.property.total.to_i != 0 && !p.property_forms.include?("CP0010(6/07) CP0090(7/88) CP0120(1/08) CP0140(7/06) CP1032(8/08) IL0935(7/02) IL0953(1/08) CP1270(9/96) ")
        p.property_forms +=  "CP0010(6/07) CP0090(7/88) CP0120(1/08) CP0140(7/06) CP1032(8/08) IL0935(7/02) IL0953(1/08) CP1270(9/96) "
      end

      if p.locations.first.limit_earnings.to_i != 0 && !p.property_forms.include?("CP0030(6/07) ")
        p.property_forms +=  "CP0030(6/07) "
      end

      if p.locations.first.spoilage.to_i != 0 && !p.property_forms.include?("CP0440(6/95) ")
        p.property_forms +=  "CP0440(6/95) "
      end

      if p.locations.first.loss_coverage.try(:downcase) == "basic" && !p.property_forms.include?("CP1010(6/07) ")
        p.property_forms +=  "CP1010(6/07) "
      elsif p.locations.first.loss_coverage.try(:downcase) == "broad" && !p.property_forms.include?("CP1020(6/07) ")
        p.property_forms +=  "CP1020(6/07) "
      elsif p.locations.first.loss_coverage.try(:downcase) == "special" && !p.property_forms.include?("CP1030(6/07) ")
        p.property_forms +=  "CP1030(6/07) "
      end

      #if p.locations.first.limit_sign.to_i != 0 && !p.property_forms.include?("CP1440(6/07) ")
      #  p.property_forms +=  "CP1440(6/07) "
      #end

      if p.locations.first.enhancement.to_i != 0 && !p.property_forms.include?("PO-PRP-3(12/13) ")
        p.property_forms +=  "PO-PRP-3(12/13) "
      end

      # crime
      if p.crime.total.to_i != 0 && !p.crime_forms.include?("CR0021(5/06) CR0110(8/07) CR0246(8/07) CR0730(3/06) CR0731(3/06) IL0935(7/02) IL0953(1/08) ")
        p.crime_forms +=  "CR0021(5/06) CR0110(8/07) CR0246(8/07) CR0730(3/06) CR0731(3/06) IL0935(7/02) IL0953(1/08) "
      end

      if p.crime.limit_theft.to_i != 0 && !p.crime_forms.include?("CR0029(5/06) ")
        p.crime_forms +=  "CR0029(5/06) "
      end

      if p.crime.limit_money.to_i != 0 && !p.crime_forms.include?("CR0405(8/07) ")
        p.crime_forms +=  "CR0405(8/07) "
      end

      if p.crime.limit_safe_burglary.to_i != 0 && !p.crime_forms.include?("CR0405(8/07) ")
        p.crime_forms +=  "CR0405(8/07) "
      end

      if p.crime.limit_safe_burglary.to_i != 0 && !p.crime_forms.include?("PO-CR-1(10/10) ")
        p.crime_forms +=  "PO-CR-1(10/10) "
      end

      if p.crime.limit_safe_burglary.to_i != 0 && !p.crime_forms.include?("CR3510(8/07) ")
        p.crime_forms +=  "CR3510(8/07) "
      end

      if p.crime.limit_premises_burglary.to_i != 0 && !p.crime_forms.include?("CR3532(8/07) ")
        p.crime_forms +=  "CR3532(8/07) "
      end

      if p.crime.limit_premises_burglary.to_i != 0 && !p.crime_forms.include?("CR0407(8/07) ")
        p.crime_forms +=  "CR0407(8/07) "
      end

      # general liability
      if p.gl.total.to_i != 0 && !p.gl_forms.include?("CG0001(12/07) CG0068(5/09) CG0099(11/85) CG0168(12/4) CG2101(11/85) CG2146(7/98) CG2147(12/07) CG2149(9/99) CG2167(12/04) CG2175(6/08) CG2190(1/06) CG2258(11/85) CG2407(1/96) IL0021(9/08) PO-GL-5(5/12) ")
        p.gl_forms +=  "CG0001(12/07) CG0068(5/09) CG0099(11/85) CG0168(12/4) CG2101(11/85) CG2146(7/98) CG2147(12/07) CG2149(9/99) CG2167(12/04) CG2175(6/08) CG2190(1/06) CG2258(11/85) CG2407(1/96) IL0021(9/08) PO-GL-5(5/12) "
      end

      if p.gl.water_gas_tank.try(:downcase) == "yes" && !p.gl_forms.include?("PO-GL-WIG(12/13) ")
        p.gl_forms +=  "PO-GL-WIG(12/13) "
      end

      # auto
      if p.auto.total.to_i != 0 && !p.auto_forms.include?("CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) ")
        p.auto_forms +=  "CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) "
      end

      p.save
    end
end
