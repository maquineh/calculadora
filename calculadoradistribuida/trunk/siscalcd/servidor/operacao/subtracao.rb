require 'drb'
class Subtracao
  def subtrair
    sub = 0
    puts"Digite um numero"
    valor=gets.chomp.to_i
    sub = valor
    loop do
        puts"Digite um numero ou 0 para terminar"
        STDOUT.flush
        n=gets.chomp.to_i
        sub = sub - n
      return sub if n == 0
      end
  end
end
DRb.start_service 'druby://localhost:8885', Subtracao.new
 puts "Servidor rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join