#file: rpnexpression
class RPNExpression
 
  # Set up the table of known operators
  Operator = Struct.new(:precedence, :associativity, :english, :ruby_operator)
  class Operator
    def left_associative?; associativity == :left; end
    def <(other)
      if left_associative? 
        precedence <= other.precedence
      else 
        precedence < other.precedence
      end
    end
  end
 
  Operators = {
    "+" => Operator.new(2, :left, "ADD", "+"),
    "-" => Operator.new(2, :left, "SUB", "-"),
    "*" => Operator.new(3, :left, "MUL", "*"),
    "/" => Operator.new(3, :left, "DIV", "/"),
    "^" => Operator.new(4, :right, "EXP", "**"),
  }
 
  # create a new object
  def initialize(str)
    @expression = str
    @infix_tree = nil
    @value = nil
  end
  attr_reader :expression
 
  # convert an infix expression into RPN
  def self.from_infix(expression)
    debug "\nfor Infix expression: #{expression}\nTerm\tAction\tOutput\tStack"
    rpn_expr = []
    op_stack = []
    tokens = expression.split
    until tokens.empty?
      term = tokens.shift
 
      if Operators.has_key?(term)
        op2 = op_stack.last
        if Operators.has_key?(op2) and Operators[term] < Operators[op2]
          rpn_expr << op_stack.pop
          debug "#{term}\t#{Operators[op2].english}\t#{rpn_expr}\t#{op_stack}\t#{op2} has higher precedence than #{term}"
        end
        op_stack << term
        debug "#{term}\tPUSH OP\t#{rpn_expr}\t#{op_stack}"
 
      elsif term == "("
        op_stack << term
        debug "#{term}\tOPEN_P\t#{rpn_expr}\t#{op_stack}"
 
      elsif term == ")"
        until op_stack.last == "("
          rpn_expr << op_stack.pop
          debug "#{term}\t#{Operators[rpn_expr.last].english}\t#{rpn_expr}\t#{op_stack}\tunwinding parenthesis"
        end
        op_stack.pop
        debug "#{term}\tCLOSE_P\t#{rpn_expr}\t#{op_stack}"
 
      else
        rpn_expr << term
        debug "#{term}\tPUSH V\t#{rpn_expr}\t#{op_stack}"
      end
    end
    until op_stack.empty?
      rpn_expr << op_stack.pop
    end
    obj = self.new(rpn_expr.join(" "))
    debug "RPN = #{obj.to_s}"
    obj
  end
 
  # calculate the value of an RPN expression
  def eval
    return @value unless @value.nil?
 
    debug "\nfor RPN expression: #{expression}\nTerm\tAction\tStack"
    stack = []
    expression.split.each do |term|
      if Operators.has_key?(term)
        a, b = stack.pop(2)
        raise ArgumentError, "not enough operands on the stack" if b.nil?
        a = a.to_f if term == "/"
        op = (term == "^" ? "**" : term)
        stack.push(a.method(op).call(b))
        debug "#{term}\t#{Operators[term].english}\t#{stack}"
      else
        begin
          number = Integer(term) rescue Float(term)
        rescue ArgumentError
          raise ArgumentError, "cannot handle term: #{term}"
        end
        stack.push(number)
        debug "#{number}\tPUSH\t#{stack}"
      end
    end
    @value = stack.pop
    debug "Value = #@value"
    @value
  end
 
  private
  # convert an RPN expression into an AST
  def to_infix_tree
    return @infix_tree unless @infix_tree.nil?
 
    debug "\nfor RPN expression: #{expression}\nTerm\tAction\tStack"
    stack = []
    expression.split.each do |term|
      if Operators.has_key?(term)
        a, b = stack.pop(2)
        raise ArgumentError, "not enough operands on the stack" if b.nil?
        op = InfixNode.new(term)
        op.left = a
        op.right = b
        stack.push(op)
        debug "#{term}\t#{Operators[term].english}\t#{stack.inspect}"
      else
        begin
          Integer(term) rescue Float(term)
        rescue ArgumentError
          raise ArgumentError, "cannot handle term: #{term}"
        end
        stack.push(InfixNode.new(term))
        debug "#{term}\tPUSH\t#{stack.inspect}"
      end
    end
    @infix_tree = stack.pop
  end
 
  public
  # express the AST as a string
  def to_infix
    expr = to_infix_tree.to_s
    debug "Infix = #{expr}"
    expr
  end
 
  # express the AST as a string, but in a form that allows Ruby to evaluate it
  def to_ruby
    expr = to_infix_tree.to_ruby
    debug "Ruby = #{expr}"
    expr
  end
 
  def to_s
    expression
  end
 
 
  private
  class InfixNode
    def initialize(value)
      @value = value
      @left = nil
      @right = nil
    end
    attr_reader :value
    attr_accessor :left, :right
 
    def leaf?
      left.nil? and right.nil?
    end
 
    def to_s;    to_string(false); end
    def to_ruby; to_string(true);  end 
 
    def to_string(to_ruby)
      result = []
      result << display_child(left, to_ruby, (to_ruby and value == "/"))
      result << (to_ruby ? Operators[value].ruby_operator : value)
      result << display_child(right, to_ruby)
      result.join(" ")
    end
 
    def display_child(child, to_ruby, need_float = false)
      result = if child.leaf?
                 child.value
               elsif Operators[child.value].precedence < Operators[value].precedence
                 "( #{child.to_string(to_ruby)} )"
               else
                 child.to_string(to_ruby)
               end
      result += ".to_f" if need_float
      result
    end
 
    def inspect
      str = "node[#{value}]"
      str << "<left=#{left.inspect}, right=#{right.inspect}>" unless leaf?
      str
    end
  end
end
 
def debug(msg)
  puts msg if $DEBUG
end