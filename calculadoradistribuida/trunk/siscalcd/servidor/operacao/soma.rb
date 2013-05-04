require 'drb'
class Soma
    def somar(v1,v2)
    valor = v1+v2
    puts "Adicao ->\s\sResultado de:  #{v1} + #{v2} = #{valor}"
    return valor
    
  end
end
DRb.start_service 'druby://localhost:8899', Soma.new
 puts "Servidor de Adicao rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join