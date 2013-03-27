require_relative 'simple'
module Selector
  #
  # Feature Selection for Text Classification - HP Labs
  # http://www.google.com/patents/US20040059697
  #
  class Forman < Selector::Simple

    def label
      "forman"
    end

    #
    # generates a list of feature vetors and their labels from preprocessed data
    # @param  data_set [Array<PreprocessedData>] list of preprocessed data
    # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    # @param  dictionary_size [Integer] Size of a dictionary to create if non exists
    #
    # @return [Array<FeatureVector>] list of feature vectors and labels
    def generate_vectors data_set, dictionary_size=DEFAULT_DICTIONARY_SIZE
      words_and_label_per_data = extract_words data_set, true
      generate_global_dictionary words_and_label_per_data, dictionary_size

      words_per_data = words_and_label_per_data.map(&:features)
      p_map_with_index(words_per_data) do |words,index|
        word_set = words.uniq
        make_vector word_set, data_set[index]
      end
    end

    #
    # generates a list of words used as dictionary
    # @param  all_words (see #extract_words)
    # @param  size dictionary size
    #
    # @return [Array<String>] list of words
    def generate_global_dictionary all_words, size=DEFAULT_DICTIONARY_SIZE
      return unless global_dictionary.empty?

      label_counts = [0,0]
      features = all_words.reduce(Hash.new { |h, k| h[k] = [0,0] }) do |accumulator, bag|
        label = bag.label ? 1 : 0
        label_counts[label] += 1
        bag.features.each do |word|
          unless accumulator.has_key?(word)
            accumulator[word] = [0,0]
          end
          accumulator[word][label] += 1
        end
        accumulator
      end
      words = p_map(features) do |word, counts|
                next if counts.any? { |e| e==0 } # skip words only appearing in one class
                false_prositive_rate = counts[0].quo(label_counts[0])
                true_prositive_rate = counts[1].quo(label_counts[1])
                bns = cdf_inverse(true_prositive_rate) - cdf_inverse(false_prositive_rate)
                [word, bns.abs]
              end
      @global_dictionary = words.compact
                                .sort_by{|e| e[1]}
                                .last(size)
                                .map{|e| e[0] }
    end

    #
    # extracts the words of all provided data entries
    # @param  data_set [Array<PreprocessedData>] list of preprocessed data
    # @param  keep_label
    #
    # @return [Array<OpenStruct<Array<String>,Boolean>>] list of words per data entry
    def extract_words data_set, keep_label=false
      data_set.map do |data|
        extract_words_from_data data, keep_label
      end
    end

    #
    # fetches all words and two word phrases from one data entry, removes stopwords and very short words
    # @param  data [PreprocessedData] preprocessed data entry
    # @param  keep_label
    #
    # @return [OpenStruct<Array<String>,Boolean>] list of words
    def extract_words_from_data data, keep_label=false
      words = (data.data.flat_map(&:split) - stopwords).delete_if { |e| e.size <= 2 }
      features = words + words.each_cons(2).map{|e| e.join " " }
      return features unless keep_label
      OpenStruct.new(
        features: features,
        label: data.label
      )
    end


    private

    SQR2 = Math.sqrt(2)
    SQR2PI = Math.sqrt(2.0*Math::PI)
    # standard normal cumulative distribution function
    def cdf(z)
      0.5 * (1.0 + Math.erf( z.quo(SQR2) ) )
    end

    # inverse standard normal cumulative distribution function
    # http://home.online.no/~pjacklam/notes/invnorm

    # Coefficients in rational approximations.
    A = [0, -3.969683028665376e+01, 2.209460984245205e+02, -2.759285104469687e+02, 1.383577518672690e+02, -3.066479806614716e+01, 2.506628277459239e+00]
    B = [0, -5.447609879822406e+01, 1.615858368580409e+02, -1.556989798598866e+02, 6.680131188771972e+01, -1.328068155288572e+01]
    C = [0, -7.784894002430293e-03, -3.223964580411365e-01, -2.400758277161838e+00, -2.549732539343734e+00, 4.374664141464968e+00, 2.938163982698783e+00]
    D = [0, 7.784695709041462e-03, 3.224671290700398e-01, 2.445134137142996e+00, 3.754408661907416e+00]
    # Define break-points.
    P_LOW  = 0.02425
    P_HIGH = 1.0 - P_LOW

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