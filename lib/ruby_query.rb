require 'nokogiri'

module RubyQuery
  class QueryError < StandardError
    attr_accessor :context, :command_name, :command_type, :param, :message
    def initialize(context, name, type, param, msg)
      @context = context
      @command_name = name
      @command_type = type
      @param = param
      @message = msg
    end
    
    def to_s
      "#{command_type}:#{command_name} param=#{param}, message=#{message}"
    end
  end

  class Query  
    # supported commands
    COMMANDS = {
      :to_html => {:type => 'method'},
      :inner_html => {:type => 'method'},
      :text => {:type => 'method'},
      :size => {:type => 'method'},
      
      :width => {:type => 'attribute'},
      :height => {:type => 'attribute'},
      :value => {:type => 'attribute'},
      :class => {:type => 'attribute'},

      :first => {:type => 'traverse'},
      :last => {:type => 'traverse'},
      :parent => {:type => 'traverse'},
      :next_sibling => {:type => 'traverse'},
      :previous_sibling => {:type => 'traverse'},
      :at => {:type => 'traverse', :arity => 1},
      
      :attr => {:type => 'proc', 
        :arity => 1, 
        :proc => Proc.new {|context, param, query| 
            context.attr(param).to_s rescue ""
        }
      },
      :hasClass => {:type => 'proc', 
        :arity => 1, 
        :proc => Proc.new {|context, param, query| 
            if context.is_a?(Nokogiri::XML::Element)
              !!context["class"].split(" ").find{|x| x == param} rescue false
            elsif context.is_a?(Nokogiri::XML::NodeSet)
              !!context.first["class"].split(" ").find{|x| x == param} rescue false
            else
              raise QueryError.new(context, name, type, param, "Cannot get hasClass from #{context.class}")
            end
        } 
      }
    }
    
    ALIAS = {
      :html => :to_html,
      :len => :length,
      :count => :size,
      :get => :at,
      :"has-class" => :hasClass,
      :val => :value
    }

    def self.query(html, *query)
      doc = Nokogiri::HTML(html)
      ctx = doc.search(query.shift)

      while method = query.shift
        command = COMMANDS[method.to_sym] || COMMANDS[ALIAS[method.to_sym]] || COMMANDS[:to_html]
        param = query.length > 0 ? (command[:arity] ? query.shift : nil) : nil
        ctx = handle_command(ctx, ALIAS[method.to_sym] || method.to_sym, command[:type], param, query)
      end

      if ctx.is_a?(Nokogiri::XML::Element) || ctx.is_a?(Nokogiri::XML::NodeSet)
        ctx = ctx.to_html
      else
        ctx
      end
    end
    
    private
    def self.handle_command(context, name, type, param=nil, query=nil)
      case type
      when 'method'
        if context.is_a?(Nokogiri::XML::Element) || context.is_a?(Nokogiri::XML::NodeSet)
          if param
            context.send(name, param)
          else
            context.send(name)
          end

        elsif context.nil?
          nil

        else
          raise QueryError.new(context, name, type, param, "Cannot apply #{name} to #{context.class}")
        end

      when 'attribute'
        if context.is_a?(Nokogiri::XML::Element)
          context[name]
        elsif context.is_a?(Nokogiri::XML::NodeSet)
          context.first[name]
        else
          raise QueryError.new(context, name, type, param, "Cannot get attr #{name} from #{context.class}")
        end
      
      when 'traverse'
        if name == :at
          if param.nil?
            raise QueryError.new(context, name, type, param, "missing at parameter")
          end
          context[param.to_i]
        else
          if context.is_a?(Nokogiri::XML::Element) || context.is_a?(Nokogiri::XML::NodeSet)
            if param
              context.send(name, param)
            else
              context.send(name)
            end
          else
            raise QueryError.new(context, name, type, param, "Cannot tranverse #{context.class}")
          end
        end

      when 'proc'
        COMMANDS[name][:proc].call(context, param, query)

      else
        raise QueryError.new(context, name, type, param, 'Unexpected type: #{type}')
      end
    end
  end
end