require 'drb'

  def self.menu
    DRb.start_service
    remote_object = DRbObject.new nil, 'druby://localhost:8874'
        opcion = 1
        loop do
           puts "1.Somar"
           puts "2.Subtrair"
           puts "3.Multiplicar"
           puts "4.Dividir"
           puts "0.Sair"
           opcion=gets.chomp.to_i
      case opcion
      when 1
        somatorio = remote_object.somar_valores
        puts "O total da soma eh: #{somatorio}"
      when 2
        subtrair = remote_object.subtrair_valores
        puts "O total da subtracao eh: #{subtrair}"
      when 3
        multi =remote_object.multiplicar_valores
        puts "O total da multiplicaco eh: #{multi}"
      when 4
        div = remote_object.dividir_valores
        puts "O total da divisao eh: #{div}"
      else
        print "Obrigado!"
        break
       end
       print "menu #{menu}"
        end
      end
 menu

