Dir[File.join(Rails.root, 'lib', 'validators', '*.rb')].each {|l| require l }
