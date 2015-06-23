require 'action_view'
require 'csv'

namespace :load do
  desc 'Add mandatory forms retroactively'
  task :forms => :environment do
    Policy.all.each do |p|
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
      if @policy.gl.total.to_i != 0 && !@policy.gl_forms.include?("CG0001(12/07) CG0068(5/09) CG0099(11/85) CG0168(12/4) CG2101(11/85) CG2146(7/98) CG2147(12/07) CG2149(9/99) CG2167(12/04) CG2175(6/08) CG2190(1/06) CG2258(11/85) CG2407(1/96) IL0021(9/08) PO-GL-5(5/12) ")
        @policy.gl_forms +=  "CG0001(12/07) CG0068(5/09) CG0099(11/85) CG0168(12/4) CG2101(11/85) CG2146(7/98) CG2147(12/07) CG2149(9/99) CG2167(12/04) CG2175(6/08) CG2190(1/06) CG2258(11/85) CG2407(1/96) IL0021(9/08) PO-GL-5(5/12) "
      end

      if @policy.gl.water_gas_tank.downcase == "yes" && !@policy.gl_forms.include?("PL-GL-WIG(12/13) ")
        @policy.gl_forms +=  "PL-GL-WIG(12/13) "
      end

      # auto
      if @policy.auto.total != 0 && !@policy.auto_forms.include?("CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) ")
        @policy.auto_forms +=  "CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) "
      end

      @policy.save
    end
  end
end
