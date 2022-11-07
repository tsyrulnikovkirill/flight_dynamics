require_relative 'constants'

def line_interpolation(x, x_data, y_data)
  n = x_data.size
  (0...n).each do |index|
    if (x_data[index]..x_data[index + 1]).include?(x)
      a1 = (y_data[index + 1] - y_data[index]) / (x_data[index + 1] - x_data[index])
      a0 = y_data[index] - a1 * x_data[index]
      return a0 + a1 * x
    end
  end
end

def interpolation_cya_alpha(mah)
  line_interpolation(mah, TABLE_M, TABLE_CYA_ALPHA)
end

def approximation_cxa(mah)
  if mah < TABLE_M[0]
    TABLE_CXA[0]
  elsif mah > TABLE_M[14]
    TABLE_CXA[14]
  elsif (TABLE_M[0]...TABLE_M[1]).include?(mah)
    TABLE_CXA[0]
  elsif (TABLE_M[1]...TABLE_M[2]).include?(mah)
    1.217 - 3.5 * mah + 3.333333 * mah * mah
  elsif (TABLE_M[2]...TABLE_M[4]).include?(mah)
    -0.61 + 1.45 * mah
  elsif (TABLE_M[4]...TABLE_M[7]).include?(mah)
    -3.31 + 7.65 * mah - 3.5 * mah * mah
  elsif (TABLE_M[7]...TABLE_M[9]).include?(mah)
    2.75 - 2.8 * mah + mah * mah
  elsif (TABLE_M[9]...TABLE_M[10]).include?(mah)
    1.116667 - 0.233333 * mah
  elsif (TABLE_M[10]...TABLE_M[12]).include?(mah)
    1.370238 - 0.508929 * mah + 0.074405 * mah * mah
  else
    0.551515 - 0.015152 * mah
  end
end
