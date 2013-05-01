require 'drb'
class Soma
    def somar
      valor  = 0
      loop do
        puts"Digite um numero ou 0 para terminar"
        STDOUT.flush
        n=gets.chomp.to_i
        valor = valor +n
      return valor if n == 0
    end
  end
end
DRb.start_service 'druby://localhost:8899', Soma.new
 puts "Servidor rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join