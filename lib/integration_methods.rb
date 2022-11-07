require_relative 'mathematical_model'
require_relative 'constants'
require_relative 'excel_data'

def euler_method(dt, alpha_zero)
  if alpha_zero
    is_angle = "α равен 0"
  else
    is_angle = "α изменяется"
  end
  excel = ExcelData.new("Эйлер при #{is_angle} с шагом #{dt}")

  t = 0
  v_old = V_0
  v_new = V_0
  tetta_c_old = TETTA_C0
  tetta_c_new = TETTA_C0
  tetta_old = TETTA_0
  tetta_new = TETTA_0
  x_old = X_0
  x_new = X_0
  y_old = Y_0
  y_new = Y_0
  wz_old = WZ0
  wz_new = WZ0
  n = 0

  while t <= T_K
    if t > T_1
      parameters = issue_parameters(n, T_1, v_new, y_new, x_new, tetta_new, tetta_c_new, wz_new)
      excel.create_line(parameters)
      n += 1
    end

    parameters = issue_parameters(n, t, v_new, y_new, x_new, tetta_new, tetta_c_new, wz_new)
    excel.create_line(parameters)

    v_new = v_old + dt * dv_dt(v_old, y_old, tetta_old, tetta_c_old, t)
    tetta_c_new = tetta_c_old + dt * d_tetta_c_dt(v_old, y_old, tetta_old, tetta_c_old, t)
    x_new = x_old + dt * dx_dt(v_old, tetta_c_old)
    y_new = y_old + dt * dy_dt(v_old, tetta_c_old)

    if alpha_zero
      tetta_new = tetta_c_new
      wz_new = d_tetta_c_dt(v_new, y_new, tetta_new, tetta_c_new, t + dt)
    else
      wz_new = wz_old + dt * dwz_dt(v_old, y_old, tetta_old, tetta_c_old)
      tetta_new = tetta_old + dt * d_tetta_dt(wz_old)
    end

    v_old = v_new
    tetta_c_old = tetta_c_new
    tetta_old = tetta_new
    x_old = x_new
    y_old = y_new
    wz_old = wz_new

    t += dt
    n += 1
  end

  excel.create_sheet
  excel.save
end

def modify_euler_method

end

def method_runge_kutta

end
