require_relative 'constants'
require_relative 'atmosphere_parameters'
require_relative 'approximation_methods'

#вспомогательные уравнения
#угол атаки
def alpha(tetta, tetta_c)
  tetta - tetta_c
end

def mah(velocity, height)
  velocity / AtmosphereParameters.new(height).parameter_sound_velocity
end

def current_mass(t)
  MASS_0 - D_MASS_DT * t
end

def thrust(height)
  2100 * D_MASS_DT + S_A *
    (AtmosphereParameters.new(0).parameter_pressure - AtmosphereParameters.new(height).parameter_pressure)
end

def force_xa(velocity, height)
  approximation_cxa(mah(velocity, height)) * S_M * AtmosphereParameters.new(height).parameter_density *
    velocity * velocity / 2
end

def force_ya(velocity, height, tetta, tetta_c)
  interpolation_cya_alpha(mah(velocity, height)) * alpha(tetta, tetta_c) * S_M *
    AtmosphereParameters.new(height).parameter_density * velocity * velocity / 2
end

def moment_z_alpha(velocity, height, tetta, tetta_c)
  amount_mah = mah(velocity, height)
  -(approximation_cxa(amount_mah) + interpolation_cya_alpha(amount_mah) * alpha(tetta, tetta_c)) * S_M *
      AtmosphereParameters.new(height).parameter_density * velocity * velocity / 2 * DELTA_L
end

#законы управления

# Производная скорости ЛА
def dv_dt(velocity, height, tetta, tetta_c, t)
  pull = thrust(height)
  cos_tetta_tetta_c = Math.cos(alpha(tetta, tetta_c))
  x_a = force_xa(velocity, height)
  acceleration = AtmosphereParameters.new(height).parameter_acceleration_free_fall

  (pull * cos_tetta_tetta_c - x_a) / current_mass(t) - acceleration * Math.sin(tetta_c)
end

# Производная угла наклона траектории
def d_tetta_c_dt(velocity, height, tetta, tetta_c, t)
  pull = thrust(height)
  sin_tetta_tetta_c = Math.sin(alpha(tetta, tetta_c))
  y_a = force_ya(velocity, height, tetta, tetta_c)
  acceleration = AtmosphereParameters.new(height).parameter_acceleration_free_fall

  ((pull * sin_tetta_tetta_c + y_a) / current_mass(t) - acceleration * Math.cos(tetta_c)) / velocity
end

def dx_dt(velocity, tetta_c)
  velocity * Math.cos(tetta_c)
end

def dy_dt(velocity, tetta_c)
  velocity * Math.sin(tetta_c)
end

def dwz_dt(velocity, height, tetta, tetta_c)
  moment_z_alpha(velocity, height, tetta, tetta_c) * alpha(tetta, tetta_c) / J_Z
end

def d_tetta_dt(w_z)
  w_z
end

def issue_parameters(n, t, v, y, x, tetta, tetta_c, wz)
  real_mah = mah(v, y)
  [n, t, current_mass(t), thrust(y), v, real_mah,
     approximation_cxa(real_mah), force_xa(v, y),
     degrees(alpha(tetta, tetta_c)), degrees(tetta_c),
     interpolation_cya_alpha(real_mah),
     force_ya(v, y, tetta, tetta_c),
     dv_dt(v, y, tetta, tetta_c, t),
     d_tetta_c_dt(v, y, tetta, tetta_c, t),
     moment_z_alpha(v, y, tetta, tetta_c),
     wz, degrees(tetta), y, dy_dt(v, tetta_c),
     x, dx_dt(v, tetta_c)
    ]
end
