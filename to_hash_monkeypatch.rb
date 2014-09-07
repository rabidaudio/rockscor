
class Object
  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end


# class Hash
#     def method_missing(name, *args, &blk)
#       if self.keys.map(&:to_sym).include? name.to_sym
#         return self[name.to_sym]
#       else
#         super
#       end
#     end
# end
