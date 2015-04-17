require 'sinatra'
require 'date'

get '/' do
  "Hola mundo!\n\nEl servicio se encuentra en https://andreihelo-sinatra.herokuapp.com/contact"
end

post '/' do
  "Hola mundo!\n\nEl servicio se encuentra en https://andreihelo-sinatra.herokuapp.com/contact"
end

get_or_post '/contact' do
  @fails = []

  if params[:person][:name].gsub(/\s+/, '').size == 0
    params[:person][:name] = 'ser anónimo'
    @fails << 'No he recibido dato de tu nombre.'
  end

  if params[:person][:genre] == 'femenino'
    something = 'te apuesto una tortilla a que de niña tuviste algunas muñecas'
  elsif params[:person][:genre] == 'masculino'
    something = 'te apuesto un calcetín usado a que de niño jugabas con carritos'
  else
    something = 'no se qué decir sobre ti'
    @fails << 'No he recibido dato de tu género.'
  end

  unless params[:person][:birthdate]
    @fails << 'No he recibido dato de tu fecha de nacimiento.'
  end

  unless params[:person][:city]
    @fails << 'No he recibido dato de ciudad.'
  end

  if params[:person][:preferences]
    geeky = params[:person][:preferences].count * 100 / 3
  else
    geeky = 0
    @fails << 'No he recibido dato de al menos una de tus preferencias.'
  end

  if !params[:message]
    @fails << 'No he recibido dato de mensaje.'
  elsif params[:message].size < 1
    @fails << 'Tu mensaje está vacío, escribe cualquier cosa.'
  end

  "Hola #{params[:person][:name]}, #{print_age(params[:person][:birthdate])}, eres de #{params[:person][:city]} y #{something},
   escribiste #{params[:message].size} caracteres y mi diagnóstico es que eres #{geeky}% geek. #{print_fails}"
end

def print_age(birthdate)
  begin
    birthdate = Date.parse(birthdate)
    today = Date.today
    age = today.year - birthdate.year -
    ((today.month > birthdate.month ||
    (today.month == birthdate.month && today.day >= birthdate.day)) ? 0 : 1)
    if age < 0
      "no creo que aún no hayas nacido"
    else
      "debes tener #{age} años"
    end
  rescue
    @fails << 'Hay un problema con el formato de tu fecha de nacimiento.'
    "no puedo calcular tu edad"
  end
end

def print_fails
  if @fails.size > 0
    message = "\nErrores:"
    @fails.each do |fail|
      message += "\n#{fail}"
    end
  else
    message = ''
  end
  message
end
