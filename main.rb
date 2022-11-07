require_relative 'lib/atmosphere_parameters'

height = STDIN.gets.to_i
atmosphere_parameters = AtmosphereParameters.new(height)

puts atmosphere_parameters.show
# real_mah = mah(v_new, y_new)
# parameters = [n, t, current_ mass(t), thrust(y_new), v_new, real_mah,
#               approximation_cxa(real_mah), force_xa(v_new, y_new),
#               degrees(alpha(tetta_new, tetta_c_new)), degrees(tetta_c_new),
#               interpolation_cya_alpha(real_mah),
#               force_ya(v_new, y_new, tetta_new, tetta_c_new),
#               dv_dt(v_new, y_new, tetta_new, tetta_c_new, t),
#               d_tetta_c_dt(v_new, y_new, tetta_new, tetta_c_new, t),
#               moment_z_alpha(v_new, y_new, tetta_new, tetta_c_new),
#               wz_new, degrees(tetta_new), y_new, dy_dt(v_new, tetta_c_new),
#               x_new, dx_dt(v_new, tetta_c_new)
# ]