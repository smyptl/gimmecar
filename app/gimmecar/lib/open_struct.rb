class Lib::OpenStruct < OpenStruct

  delegate :fetch, :merge, to: :to_h

end
