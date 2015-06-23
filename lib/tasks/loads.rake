require 'action_view'
require 'csv'

namespace :load do
  desc 'Add mandatory forms retroactively'
  task :forms => :environment do
    Policy.all.each do |p|
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
      if p.auto.total.to_i != 0 && !p.auto_forms.include?("CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) ")
        p.auto_forms +=  "CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) "
      end

      p.save
    end
  end
end
