=begin
@@variables = [{}] 
@@functions = {} 
@@function_param = {} 
@@scope = 0
@@return = nil 

@@type_table = {String => "<57r1ng>", Integer => "<1n7>", 
   Float => "<fl0a7>", Bool => "<b00l>", List => "<l175>"}
@@type_value = {"<57r1ng>" => "", "<1n7>" => 0, "fl0a7" => 0.0, "<b00l>" => "true", "<l157>" => []}
=end

@@variables = {}
class Scope
    def start_scope
        @@scope += 1
        @@variables.push({})
    end

    def end_scope
        @@variables.pop
        @@scope -= 1
        if @@scope < 0
            abort("EROOOOOOOOOORRRRR")
        end
    end

    def check(var, table)
        if table == @@function_param
            table[var]
        elsif table == @@variables
            start = @@scope
            while( start >= 0 )
                if @@variables[start][var] != nil
                    return @@variables[start][var]
                end
                start -= 1
            end
            if @@variables[0][var] == nil
                abort("ERROR: The variable \'#{var}\' doesn't exist!")
            end
        end
    end
end  

class StmtListNode
    attr_accessor :stmt_list, :stmt
    def initialize (stmt_list, stmt)
        @stmt_list = stmt_list
        @stmt = stmt
    end
    def eval
        @stmt.eval
        @stmt_list.eval unless @stmt_list.nil?
    end
end
#========================================== CALCULATIONS
class ArithmNode
    attr_accessor :lhs, :op, :rhs
    def initialize(lhs, op, rhs)
        @lhs = lhs
        @op = op
        @rhs = rhs
    end
  
    def eval
        return instance_eval("#{lhs.eval} #{op} #{rhs.eval}")
    end
end

class CompNode
    attr_accessor :lhs, :op, :rhs
    def initialize(lhs, op, rhs)
        @lhs = lhs
        @op = op
        @rhs = rhs
    end

    def eval
        return BoolNode.new(instance_eval("#{lhs.eval} #{op} #{rhs.eval}")).eval
    end
end

class LogicNode
    attr_accessor :lhs, :op, :rhs
    def initialize(lhs, op, rhs)
        @lhs = lhs
        @op = op
        @rhs = rhs
    end

    def eval
        if @op == "and"
            @op = "and"
        elsif @op == "or"
            @op = "or"
        end        
        return BoolNode.new(instance_eval("#{lhs.eval} #{op} #{rhs.eval}")).eval
    end
end

class NotLogicNode
    attr_accessor :op, :rhs
    def initialize(op, rhs)
        @op = op
        @rhs = rhs
    end

    def eval
        if @op == "not"
            @op = "not"
        end        

        return BoolNode.new(instance_eval("#{op} #{rhs.eval}")).eval
    end
end 
#========================================== Values
class FactorNode
    attr_accessor :value
    def initialize(value)
        @value = value
    end
    
    def eval
        return @value
    end
end

class BoolNode
    attr_accessor :value
    def initialize(value)
        if value == true or value == "true" 
            value = true
        elsif value == false or value == "false"
            value = false
        end
        @value = value
    end

    def eval
        return @value
    end
end
#========================================== Print and Return
class PrintNode
    attr_accessor :value
    def initialize(value)
        @value = value
    end

    def eval
        print "#{@value.eval}\n"
    end
end

class ReturnNode
    attr_accessor :value
    def initialize(value)
        @value = value
    end

    def eval
        return @value.eval
    end
end

=begin
class VarNode 
    attr_accessor :identifier
    def initialize(var)
        @identifier = var
    end

    def eval
        start = @@scope
        if function_param.has_key?(@identifier) == true
            return Scope.check(@identifier, @@function_param) 
        else 
            return Scope.check(@identifier, @@variables) 
        end
    end
end
=end