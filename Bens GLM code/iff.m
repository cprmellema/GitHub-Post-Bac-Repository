function result = iff(predicate, trueValue, falseValue)
% y = IFF(predicate, trueValue, falseValue)
% Return trueValue if the predicate is non-zero, falseValue if it's zero.
% This is like the ?: operator in C, but without short-circuit evaulation.

if (predicate),
  result = trueValue;
else
  result = falseValue;
end