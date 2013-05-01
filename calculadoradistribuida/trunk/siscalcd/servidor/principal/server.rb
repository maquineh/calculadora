require 'drb'
class Server
  def somar_valores
    DRb.start_service
    sub_remota = DRbObject.new nil, 'druby://localhost:8899'
    return sub_remota.somar
  end
  def subtrair_valores
    DRb.start_service
    sub_remota = DRbObject.new nil, 'druby://localhost:8885'
    return sub_remota.subtrair
  end
  def multiplicar_valores
    DRb.start_service
    sub_remota = DRbObject.new nil, 'druby://localhost:8898'
    return sub_remota.multiplicar
  end
  def dividir_valores
    DRb.start_service
    sub_remota = DRbObject.new nil, 'druby://localhost:8880'
    return sub_remota.dividir
  end
end
 DRb.start_service 'druby://localhost:8874', Server.new
 puts "Servidor rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join