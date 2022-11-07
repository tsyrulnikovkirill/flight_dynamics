require 'axlsx'

class ExcelData

  def initialize(name_sheet)
    @name_sheet = name_sheet
    @p = Axlsx::Package.new
    @wb = @p.workbook
    @lines = []
  end

  def head_text(sheet)
    sheet.add_row ['N', 't, с', 'm, кг' ,'P, Н', 'V, м/с', 'M', 'Cxa', 'Xa, Н', 'α, град', 'θс, град',
                   'Cya_α', 'Ya, Н', 'dV/dt, м/с2', 'dθс/dt, 1/с', 'Mz_α, кг*м2/с2', 'ωz, 1/с', 'ϑ, град',
                   'y, м', 'dy/dt, м/с', 'x, м', 'dx/dt, м/с']
  end

  def create_line(parameters)
    @lines << parameters
  end

  def create_sheet
    @wb.add_worksheet(name: @name_sheet) do |sheet|
      head_text(sheet)
      @lines.each do |line|
        sheet.add_row(line)
      end
    end
  end

  def save
    @p.serialize '_Результаты расчета_.xlsx'
  end
end
