require 'drb'
class Server
  def somar_valores(v1,v2)
    DRb.start_service
    sub_remota = DRbObject.new nil, 'druby://localhost:8899'
    puts "Requisitando servidor de Adicao..."
    return sub_remota.somar v1,v2
  end
  def subtrair_valores(v1,v2)
    DRb.start_service
    sub_remota = DRbObject.new nil, 'druby://localhost:8885'
    puts "Requisitando servidor de Subtracao..."
    return sub_remota.subtrair v1,v2
  end
  def multiplicar_valores(v1,v2)
    DRb.start_service
    sub_remota = DRbObject.new nil, 'druby://localhost:8898'
    puts "Requisitando servidor de Multiplicacao..."
    return sub_remota.multiplicar v1,v2
  end
  def dividir_valores(v1,v2)
    DRb.start_service
    sub_remota = DRbObject.new nil, 'druby://localhost:8880'
    puts "Requisitando servidor de Divisao..."
    return sub_remota.dividir v1,v2
  end
  def finalizar_calculo()
    puts "______________________ Fim da expressao ____________________________"
  end
end
 DRb.start_service 'druby://localhost:8874', Server.new
 puts "Servidor Principal rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join