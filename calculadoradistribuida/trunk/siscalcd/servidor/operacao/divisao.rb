require 'drb'
class Divisao
  def dividir
      puts"Digite o primeiro numero "
      STDOUT.flush
      n=gets.chomp.to_i

      puts"Digite o segundo numero"
      STDOUT.flush
      n2=gets.chomp.to_i
      if n2==0
        puts"Error nao se pode dividir por zero"
      else
      div=n/n2
      end
      return div
  end
end
DRb.start_service 'druby://localhost:8880', Divisao.new
 puts "Servidor rodando em...: #{DRb.uri}"
 
 trap("INT") { DRb.stop_service }
 DRb.thread.join