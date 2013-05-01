require 'drb'
class Multiplicacao
  def multiplicar
    mult=1
    loop do
      puts"Digite um numero ou 0 para terminar"
      STDOUT.flush
      n=gets.chomp.to_i
      if n== 0 
        return mult
      else mult=mult*n
     end 
    end
  end
end
DRb.start_service 'druby://localhost:8898', Multiplicacao.new
 puts "Servidor rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join