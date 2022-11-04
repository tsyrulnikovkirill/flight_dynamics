class AtmosphereParameters
  attr_accessor :height, :parameter_geopotential_height, :parameter_acceleration_free_fall, :parameter_temperature,
                :parameter_pressure, :parameter_density, :parameter_sound_velocity

  RADIUS = 6356767.0  # условный радиус Земли в метрах
  G_0 = 9.80665  # ускорение свободного падения на уровне моря
  R_CONST = 287.053
  P_0 = 101325.0

  def constants
    case @height
    when (-2000...0)
      t1 = 301.15; betta = -0.0065; h1 = -2000; p1 = 127783.0
    when (0...11019)
      t1 = 288.15; betta = -0.0065; h1 = 0; p1 = 101325.0
    when (11019...20063)
      t1 = 216.65; betta = 0; h1 = 11000; p1 = 22632.0
    when (20063...32162)
      t1 = 216.65; betta = 0.001; h1 = 20000; p1 = 5474.87
    when (32162...47350)
      t1 = 228.65; betta = 0.0028; h1 = 32000; p1 = 868.014
    when (47350...51412)
      t1 = 270.65; betta = 0; h1 = 47000; p1 = 110.906
    when (51412...71802)
      t1 = 270.65; betta = -0.0028; h1 = 51000; p1 = 66.9384
    when (71802...86152)
      t1 = 214.65; betta = -0.002; h1 = 71000; p1 = 3.95639
    end

    { 't1' => t1, 'betta' => betta, 'h1' => h1, 'p1' => p1 }
  end

  def initialize(height)
    @height = height
    @t1 = constants['t1']
    @betta = constants['betta']
    @h1 = constants['h1']
    @p1 = constants['p1']
    @parameter_geopotential_height = geopotential_height
    @parameter_acceleration_free_fall = acceleration_free_fall
    @parameter_temperature = temperature
    @parameter_pressure = pressure
    @parameter_density = density
    @parameter_sound_velocity = sound_velocity
  end

  # получение геопотенциальной высоты
  def geopotential_height
    RADIUS * @height / (RADIUS + @height)
  end

  # получение ускорения свободного падения на определенной высоте
  def acceleration_free_fall
    G_0 * (RADIUS / (RADIUS + @height)) ** 2
  end

  def temperature
    @t1 + @betta * (@parameter_geopotential_height - @h1)
  end

  def pressure
    if @betta == 0
      lgp = Math::log10(@p1) - 0.434294 * G_0 * (@parameter_geopotential_height - @h1) /
        (R_CONST * @parameter_temperature)
    else
      lgp = Math::log10(@p1) - G_0 * Math::log10(@parameter_temperature / @t1) / (R_CONST * @betta)
    end

    10 ** lgp
  end

  def sound_velocity
    20.0468 * @parameter_temperature ** (0.5)
  end

  def density
    @parameter_pressure / (R_CONST * @parameter_temperature)
  end

  def show
    output_parameters = []
    output_parameters << "Геопотенциальная высота: #{@parameter_geopotential_height.round(0)}"
    output_parameters << "Кинетическая температура: #{@parameter_temperature.round(3)}"
    output_parameters << "Давление: #{@parameter_pressure.round(2)}"
    output_parameters << "Плотность: #{@parameter_density.round(5)}" #нужно быть аккуратным при большой высоте - округляет до 1.0e-05
    output_parameters << "Ускорение свободного падения: #{@parameter_acceleration_free_fall.round(4)}"
    output_parameters << "Скорость звука: #{@parameter_sound_velocity.round(2)}"

    output_parameters
  end
end
