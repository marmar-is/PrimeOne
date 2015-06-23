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

      if p.locations.first.limit_sign.to_i != 0 && !p.property_forms.include?("CP1440(6/07) ")
        p.property_forms +=  "CP1440(6/07) "
      end

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
      if p.auto.total != 0 && !p.auto_forms.include?("CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) ")
        p.auto_forms +=  "CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) "
      end

      p.save
    end

    # Read from an excel
    def readWorkbook
      # open the speadsheet
      workbook = Roo::Spreadsheet.open(params[:file], extension: :xlsx)

      workbook.default_sheet = 'Rating'

      @policy.name= workbook.cell('C',3)
      @policy.quoted_by= workbook.cell('B',1)
      #@policy.date= workbook.cell('B',2)
      @policy.effective_date= workbook.cell('F',7)
      @policy.expiration_date= workbook.cell('J',7)

      @policy.dba= workbook.cell('B',4),
      @policy.business_type= workbook.cell('L',5)
      @policy.mortgagee= workbook.cell('S',3)

      @policy.street= workbook.cell('C',5)
      @policy.city= workbook.cell('B',6)
      @policy.state= workbook.cell('G',6)
      @policy.zip= workbook.cell('K',6).to_i.to_s

      # Property
      @policy.property.schedule_rating_pct= workbook.cell('J',36)
      @policy.property.premium_subtotal= workbook.cell('J',35)
      @policy.property.premium_total= workbook.cell('M',41)

      @policy.property.locations.destroy_all # no duplicates
      # First location (locations.first)
      #locationFields = {
      @policy.property.locations.create!(
        number: 1, premium: workbook.cell('N',33),
        co_ins: workbook.cell('L',14), co_ins_factor: workbook.cell('L',15),
        ded: workbook.cell('B',15), ded_factor: workbook.cell('G',15),

        street: workbook.cell('C',10), city: workbook.cell('B',11),
        state: workbook.cell('G',11), zip: workbook.cell('K',11).to_i.to_s,

        business_type: workbook.cell('L',10), coverage_type: workbook.cell('D',12),
        protection_class: workbook.cell('L',12), updates: workbook.cell('K',13),
        year_built: workbook.cell('B',13).to_i.to_s, construction_type: workbook.cell('H',13),
        stories: workbook.cell('E',13).to_i, square_feet: workbook.cell('B',14).to_i,
        parking_lot: workbook.cell('H',14).to_i,

        #food_limit: workbook.cell('F',17),
        food_rate: workbook.cell('H',17),
        food_premium: workbook.cell('J',17),

        theft_limit: workbook.cell('F',18),
        #theft_rate: workbook.cell('H',18),
        theft_premium: workbook.cell('J',18),

        #enhc_limit: workbook.cell('F',19),
        enhc_rate: workbook.cell('H',19),
        enhc_premium: workbook.cell('J',19),

        #mech_limit: workbook.cell('F',20),
        #mech_rate: workbook.cell('H',20),
        mech_premium: workbook.cell('J',20)
      )
      #if (!@policy.property.locations.where(number:1).exists?)
      #@policy.property.locations.create!(locationFields)

      for i in 23..29 do
        @policy.property.locations.first.exposures.create!(
        name: (workbook.cell('A',i) || ""),
        valuation: (workbook.cell('D',i) || ""),
        limit: (workbook.cell('F',i) || 0),
        rate: (workbook.cell('H',i) || 0),
        ded_factor: (workbook.cell('J',i) || 0),
        co_ins_factor: (workbook.cell('L',i) || 0),
        premium: (workbook.cell('O',i) || 0)
        )
      end
      #else
        #@policy.property.locations.first.update(locationFields)
      #end

      # Earnings should have all 0s
      @policy.property.locations.first.exposures.third.update(valuation: 0,
      ded_factor: 0, co_ins_factor: 0 )

      # Second location (locations.second) (optional)
      if (workbook.cell('T',10) != nil)
        @policy.property.locations.create!(
          number: 2, premium: workbook.cell('AE',33), co_ins: workbook.cell('AC',14),
          co_ins_factor: workbook.cell('AC',15), ded: workbook.cell('S',15),
          ded_factor: workbook.cell('X',15),

          street: workbook.cell('T',10), city: workbook.cell('S',11),
          state: workbook.cell('X',11), zip: workbook.cell('AB',11).to_i.to_s,

          business_type: workbook.cell('AC',10), coverage_type: workbook.cell('U',12),
          protection_class: workbook.cell('AC',12), updates: workbook.cell('AB',13),
          year_built: workbook.cell('S',13), construction_type: workbook.cell('Y',13),
          stories: workbook.cell('V',13).to_i, square_feet: workbook.cell('S',14).to_i,
          parking_lot: workbook.cell('Y',14).to_i,

          #food_limit: workbook.cell('W',17),
          food_rate: workbook.cell('Y',17),
          food_premium: workbook.cell('AA',17),

          theft_limit: workbook.cell('W',18),
          #theft_rate: workbook.cell('Y',18),
          theft_premium: workbook.cell('AA',18),

          #enhc_limit: workbook.cell('W',19),
          enhc_rate: workbook.cell('Y',19),
          enhc_premium: workbook.cell('AA',19),

          #mech_limit: workbook.cell('W',20),
          #mech_rate: workbook.cell('Y',20),
          mech_premium: workbook.cell('AA',20)
        )

        for i in 23..29 do
          @policy.property.locations.second.exposures.create!(
          name: (workbook.cell('R',i) || ""),
          valuation: (workbook.cell('U',i) || ""),
          limit: (workbook.cell('W',i) || 0),
          rate: (workbook.cell('Y',i) || 0),
          ded_factor: (workbook.cell('AA',i) || 0),
          co_ins_factor: (workbook.cell('AC',i) || 0),
          premium: (workbook.cell('AF',i) || 0)
          )
        end

        # Earnings should have all 0s
        @policy.property.locations.second.exposures.third.update(valuation: 0,
        ded_factor: 0, co_ins_factor: 0 )
      end

      # Crime
      @policy.crime.premium_total= workbook.cell('M',62)
      @policy.crime.premium_subtotal= workbook.cell('J',56)
      @policy.crime.schedule_rating= workbook.cell('J',57)
      @policy.crime.burglar_alarm= workbook.cell('F',44)
      @policy.crime.exclude_safe= workbook.cell('F',45)
      @policy.crime.ded= workbook.cell('K',44)

      @policy.crime.exposures.destroy_all # no duplications

      for i in 47..51 do
        @policy.crime.exposures.create!(
        name: workbook.cell('A',i), limit: workbook.cell('F',i),
        premium: workbook.cell('K',i)
        )
      end

      @policy.gl.exposure_gls.destroy_all # no duplications

      for i in 76..84 do
        if (workbook.cell('A',i) != nil)
          @policy.gl.exposure_gls.create!(
            name: "exposure_#{i-75}",
            loc_number: workbook.cell('A',i),
            description: workbook.cell('C',i),
            cov: workbook.cell('B',i),
            code: workbook.cell('H',i),
            premium_basis: workbook.cell('I',i),
            sales_type: workbook.cell('K',i),
            base_rate: workbook.cell('M',i),
            ilf: workbook.cell('O',i),
            premium: workbook.cell('Q',i)
          )
        end
      end

      @policy.gl.gas_premium= workbook.cell('M',88)
      @policy.gl.rate= workbook.cell('J',88)
      @policy.gl.water_gas_tank= workbook.cell('F',88)
      @policy.gl.add_ins_number= workbook.cell('F',87)
      @policy.gl.territory= workbook.cell('B',65).to_i
      @policy.gl.comments= (workbook.cell('B',99) || "none")

      @policy.gl.gen_agg= workbook.cell('F',67)
      @policy.gl.products_completed_operations= workbook.cell('F',68)
      @policy.gl.personal_advertising_injury= workbook.cell('F',69)
      @policy.gl.each_occurence= workbook.cell('F',70)
      @policy.gl.fire_damage= workbook.cell('F',71)
      @policy.gl.medical_expense= workbook.cell('F',72)

      if (workbook.cell('A',89) == nil)
        # General Liability
        @policy.gl.premium_total= workbook.cell('N',99)
        @policy.gl.premium_subtotal= workbook.cell('Q',89)
        @policy.gl.schedule_rating= workbook.cell('Q',91)
        @policy.gl.multi_loc_factor= workbook.cell('Q',90)

        # Commerical Auto
        @policy.auto.premium_total= workbook.cell('N',107)
        @policy.auto.locations= workbook.cell('K',102)
        @policy.auto.hired_auto= workbook.cell('F',103)
        @policy.auto.hired_auto_premium= workbook.cell('Q',103)

        @policy.package_premium_total= workbook.cell('N',109)
      else
        # General Liability
        @policy.gl.premium_total= workbook.cell('N',101)
        @policy.gl.premium_subtotal= workbook.cell('Q',91)
        @policy.gl.schedule_rating= workbook.cell('Q',93)
        @policy.gl.multi_loc_factor= workbook.cell('Q',92)

        # Commerical Auto
        @policy.auto.premium_total= workbook.cell('N',109)
        @policy.auto.locations= workbook.cell('K',104)
        @policy.auto.hired_auto= workbook.cell('F',105)
        @policy.auto.hired_auto_premium= workbook.cell('Q',105)

        @policy.package_premium_total= workbook.cell('N',111)
      end
    end
end
