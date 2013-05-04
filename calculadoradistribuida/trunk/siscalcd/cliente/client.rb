require 'drb'
require 'rpnexpression.rb' #lib para corrigir um expressão numerica no formato rpn
class Array
    alias :peek :last
end
#Cria a pilha
pilha = Array.new
DRb.start_service
remote_object = DRbObject.new nil, 'druby://localhost:8874'



while true
    puts "Calculadora Distribuida"
    print " >> Digite a expressao numerica: "
    rpn = gets.chomp
    #Expressão para adicionar espaços em branco antes e depois de caracteres não numéricos
    rpn = rpn.to_s.gsub(/[\+\-\*\/\(\)]/) {|c| ' ' + c.to_s + ' '}
    puts rpn
    
    linha = RPNExpression.from_infix(rpn).to_s
    
    
    while linha.size > 0

        # Checa primeiro por um numero se pegar um +/- usa como operador
        if linha =~ /^\s*([-+]?[0-9]*\.?[0-9]+)\s*/
            # encontrou operando então dá um push na pilha e muda pra float
            pilha.push $1.to_f
        elsif linha =~ /^\s*([\+\-\*\/])\s*/ then
            # a linha tem um operador (+/-*).
            operador = $1

            # tira os operandos da pilha.
            operando2 = pilha.pop
            operando1 = pilha.pop

            # Avalia a expressoa e dá o push pra pilha.
            pilha.push  case operador 
                when '+'
                    remote_object.somar_valores(operando1,operando2)
                when '-'
                    remote_object.subtrair_valores(operando1,operando2)
                when '*'
                    remote_object.multiplicar_valores(operando1,operando2)
                when '/'
                    remote_object.dividir_valores(operando1,operando2)
                end
        end

        # Dá um replace por string em branco
        linha.sub!($&, "")
    end

     if (linha.size == 0)
        remote_object.finalizar_calculo()            
     end
    puts "resultado = #{pilha.peek}"
end