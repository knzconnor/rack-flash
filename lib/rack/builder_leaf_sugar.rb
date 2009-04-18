# module Rack
#   module BuilderBackReference
#     def self.rack_builder
#       @rack_builder
#     end
#     def self.rack_builder=(value)
#       @rack_builder = value
#     end
#   end
#   module BuilderLeafSugar
#     def use(middleware, *args, &block)
#       middleware.include BuilderBackReference
#       middleware.rack_builder = self
#       @ins << lambda { |app| 
#         middleware.new(app, *args, &block) 
#       }
#     end
# 
#     def run(app)
#       app.class.include BuilderBackReference
#       app.class.rack_builder = self
#       def klass.rack_builder
#         @rack_builder
#       end
#       @ins << app #lambda { |nothing| app }
#     end
#     
#     def leaf_app
#       ins.last
#     end
#   end
# end