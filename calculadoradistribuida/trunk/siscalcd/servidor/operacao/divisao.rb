require 'drb'
class Divisao
  def dividir(v1,v2)
      valor = v1 / v2
      puts "Divisao ->\s\sResultado de:  #{v1} / #{v2} = #{valor}"
      return v1/v2
  end
end
DRb.start_service 'druby://localhost:8880', Divisao.new
 puts "Servidor de Divisao rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join