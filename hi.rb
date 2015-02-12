require 'sinatra'
require 'date'

get '/hi' do
  "Hola mundo!"
end

post '/contact' do
  if params[:person][:genre] == 'femenino'
    something = 'te apuesto una tortilla a que de niña tuviste algunas muñecas'
  elsif params[:person][:genre] == 'masculino'
    something = 'te apuesto un calcetín usado a que de niño jugabas con carritos'
  else
    something = 'no se qué decir sobre ti'
  end

  if params[:person][:name].gsub(/\s+/, '').size == 0
    params[:person][:name] = 'ser anónimo'
  end

  geeky = params[:person][:preferences] ? params[:person][:preferences].count * 100 / 3 : 0

  if params[:person][:birthdate]
    "Hola #{params[:person][:name]}, #{print_age(params[:person][:birthdate])}, eres de #{params[:person][:city]} y #{something},
    escribiste #{params[:message].size} caracteres y mi diagnóstico es que eres #{geeky}% geek."
  else
    "Hola #{params[:person][:name]}, sin tu fecha de nacimiento no puedo calcular tu edad, eres de #{params[:person][:city]} y #{something},
    escribiste #{params[:message].size} caracteres y mi diagnóstico es que eres #{geeky}% geek."
  end
end

def print_age(birthdate)
  begin
    birthdate = Date.parse(birthdate)
    today = Date.today
    age = today.year - birthdate.year -
    ((today.month > birthdate.month ||
    (today.month == birthdate.month && today.day >= birthdate.day)) ? 0 : 1)
    "debes tener #{age} años"
  rescue
    "no puedo calcular tu edad"
  end
end
