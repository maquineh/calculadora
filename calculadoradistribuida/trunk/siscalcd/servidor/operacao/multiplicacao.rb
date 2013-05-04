require 'drb'
class Multiplicacao
  def multiplicar(v1,v2)
    puts "Multiplicacao ->\s\sResultado de:  #{v1} * #{v2} = #{v1*v2}"
    return v1*v2
  end
end
DRb.start_service 'druby://localhost:8898', Multiplicacao.new
 puts "Servidor de Multiplicacao rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join