module AbstractReflection
  module MethodMirror
    def source
    end

    def line
    end

    def selector
    end

    def file
    end

    def source= string
    end

    def file= string
    end

    def line= string
    end

    def send_offsets
    end

    def step_offsets
    end

    def break(step_offset = 1)
    end

    def breakpoints
    end

    def in_class
    end

    def is_proc?
    end

    def is_alias?
    end

    def sends_message?(string)
    end
  end
end
