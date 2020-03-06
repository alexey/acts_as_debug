# ActAsDebug

module Debug

      def act_as_debug(var, options = {})
        options ||= {}
        @toFile = false
        default_options = {:mode => 'full'}
        options = default_options.merge(options)
        toDebug ||= {}
        options.stringify_keys.sort.each do |pair|
          option, param = pair[0], pair[1]
          case option
            when "mode" #is default
              case param
                when "full", "f"
                  toDebug[:class] = var.class
                  if var.respond_to?(:attributes)
                    toDebug[:attributes] = var.attributes
                  end
                when "compact", "c"
                  toDebug[:class] = var.class
                  @style = "c"
                else
              end # case param
            when "file"
              @toFile = "act_as_debug"
              @toFile = param if param
          end # case option
        end # options each

        line = "⊕" * 30 + " αct_αs_ΔΣβug " + "⊕" * 30
        @sLine = ""
        log line
        log "  Mode: #{options.inspect}"
        log "  Date: " + Time.now.strftime("%H:%M:%S  %d %b %Y.")
        toDebug.each do | output |
          @sLine += "〉"
          n = false
          # public_methods
          if output[1].is_a?(Hash)
            # output[1].instance_variables
            log "#{@sLine} ClassName : #{output.class} has: #{var.instance_variables}"
            log "#{@sLine}   HasAttributes in: #{output[1].class}"    
            n=true
            inspect_array(output[1])
          end #if hash

          if output[1].to_s == "Array"
            log "#{@sLine} ClassName : #{output[1]}"
            log "#{@sLine} inArrayData : (#{var.size} elements)"
            for sVar in var
              if sVar.respond_to?('attributes')
                inspect_object(sVar)
               else
                log "#{@sLine}    (#{sVar.class})    #{sVar}"
              end # if 
            end # for
          elsif output[1].to_s == "HashWithIndifferentAccess"
            log "#{@sLine} ClassName : #{output[1]}"
            log "#{@sLine} inHashData : (#{var.size} elements as array)"
            inspect_array(var)
          else
            unless n
              log "#{@sLine} ClassName : #{output[1]}"
              addInstance = ""
              addInstance = "has #{var.instance_variables} as instance variable(s)." if var.respond_to?('attributes')
              log "#{@sLine} Value     : #{var} #{addInstance}"
            end
          end # if array
        end # toDebug
        log line
        log ""
      end #def
       alias debug act_as_debug

    def inspect_object(sVar)
        log "#{@sLine} ClassName: #{sVar}"
        @sLine +=">"
        sVar.attributes.each do | render |
          dump = trunc(render[1])
          log "#{@sLine}    (#{render[1].class})   #{render[0]} = #{dump}"
        end # render
    end
    
    def inspect_array(sVar)
      @sLine += ">"
      sVar.each do | render |          
         log "#{@sLine}    (#{render[1].class})   #{render[0]} = #{trunc(render[1])}"
      end # render output[1]
    end
    
    def trunc(from)
      truncated = from
      if from.is_a?(String)
        truncated = from.slice(0..80)+" ...<truncated>" if from.size > 80
      end
      return truncated
    end
    
    private
    def log(str)
      if @toFile
        path = "#{RAILS_ROOT}/log"
        File.open("#{path}/#{@toFile}.log", "a") do | file |
          file.puts(str)
        end
       else
        logger.info str
      end
    end

end # Debug