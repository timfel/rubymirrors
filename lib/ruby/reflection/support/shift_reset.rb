# -*- coding: utf-8 -*-
# Modeled after Andrzej Filinski's article "Representing
# Monads" at POPL'94, and a Scheme implementation of it.
# http://citeseer.ist.psu.edu/filinski94representing.html
#
# Copyright 2004–2011 Christian Neukirchen
module ShiftReset
  @@metacont = lambda do |x|
    raise RuntimeError, "You forgot the top-level reset..."
  end

  def reset(&block)
    mc = @@metacont
    callcc do |k|
      @@metacont = lambda do |v|
        @@metacont = mc
        k.call v
      end
      x = block.call
      @@metacont.call x
    end
  end

  def shift(&block)
    callcc do |k|
      @@metacont.call block.call(lambda {|*v| reset { k.call *v } })
    end
  end
end
