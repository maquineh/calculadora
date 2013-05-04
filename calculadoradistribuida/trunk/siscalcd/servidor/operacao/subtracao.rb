require 'drb'
class Subtracao
  def subtrair(v1,v2)
      puts "Subtracao ->\s\sResultado de:  #{v1} - #{v2} = #{v1-v2}"
      return v1-v2
  end
end
DRb.start_service 'druby://localhost:8885', Subtracao.new
 puts "Servidor de Subtracao rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join