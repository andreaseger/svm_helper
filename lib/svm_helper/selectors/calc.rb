module Selector
  # module which provides methods to calculate the information gain
  module IG

    def information_gain(pos, neg, tp, fp)
      fn = neg - fp
      tn = pos - tp
      p_word = (tp + fp).quo(pos + neg)

      e(pos, neg) - (p_word * e(tp, fp) + (1 - p_word) * e(fn, tn))
    end

    # TODO
    # @param [Float] x
    # @param [Float] y
    def e(x,y)
      -xlx(x.quo(x+y)) -xlx(y.quo(x+y))
    end

    # calculates x*log2(x)
    # @param [Float] x
    #
    # @return [Float] x* log2(x)
    def xlx(x)
      x * Math.log2(x)
    end
  end

  # module which provides methods to calculate Bi-Normal-Seperation
  module BNS
    # Square of 2
    SQR2 = Math.sqrt(2)
    # Square of 2 pi
    SQR2PI = Math.sqrt(2.0*Math::PI)

    def bi_normal_seperation pos, neg, tp, fp
      false_prositive_rate = fp.quo(neg)
      true_prositive_rate = tp.quo(pos)
      cdf_inverse(true_prositive_rate) - cdf_inverse(false_prositive_rate)
    end

    # standard normal cumulative distribution function
    # @param [Float] z
    def cdf(z)
      0.5 * (1.0 + Math.erf( z.quo(SQR2) ) )
    end

    # inverse standard normal cumulative distribution function
    # http://home.online.no/~pjacklam/notes/invnorm

    # Coefficients in rational approximations.
    A= [0, -3.969683028665376e+01, 2.209460984245205e+02, -2.759285104469687e+02, 1.383577518672690e+02, -3.066479806614716e+01, 2.506628277459239e+00]
    B= [0, -5.447609879822406e+01, 1.615858368580409e+02, -1.556989798598866e+02, 6.680131188771972e+01, -1.328068155288572e+01]
    C= [0, -7.784894002430293e-03, -3.223964580411365e-01, -2.400758277161838e+00, -2.549732539343734e+00, 4.374664141464968e+00, 2.938163982698783e+00]
    D= [0, 7.784695709041462e-03, 3.224671290700398e-01, 2.445134137142996e+00, 3.754408661907416e+00]

    # lower breakpoint
    P_LOW  = 0.02425
    # upper breakpoint
    P_HIGH = 1.0 - P_LOW

    #
    # inverse standard normal cumulative distribution function
    def cdf_inverse(p)
      return 0.0 if p < 0 || p > 1 || p == 0.5
      x = 0.0

      if 0.0 < p && p < P_LOW
        # Rational approximation for lower region.
        q = Math.sqrt(-2.0*Math.log(p))
        x = (((((C[1]*q+C[2])*q+C[3])*q+C[4])*q+C[5])*q+C[6]) /
            ((((D[1]*q+D[2])*q+D[3])*q+D[4])*q+1.0)
      elsif P_LOW <= p && p <= P_HIGH
        # Rational approximation for central region.
        q = p - 0.5
        r = q*q
        x = (((((A[1]*r+A[2])*r+A[3])*r+A[4])*r+A[5])*r+A[6])*q /
            (((((B[1]*r+B[2])*r+B[3])*r+B[4])*r+B[5])*r+1.0)
      elsif P_HIGH < p && p < 1.0
        # Rational approximation for upper region.
        q = Math.sqrt(-2.0*Math.log(1.0-p))
        x = -(((((C[1]*q+C[2])*q+C[3])*q+C[4])*q+C[5])*q+C[6]) /
             ((((D[1]*q+D[2])*q+D[3])*q+D[4])*q+1.0)
      end
      if 0 < p && p < 1
        u = cdf(p) * SQR2PI * Math.exp((x**2.0)/2.0)
        x = x - u/(1.0 + x*u/2.0)
      end
      x
    end
  end
end
