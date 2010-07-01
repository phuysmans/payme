module Sogenactif
  module ResponseBinary
    def self.included(klass)
      klass.class_eval do
        
        #
        # Executes the binary call, gets the datas
        # Validates that the the code is correct
        # And returns the form
        #
        def launch
          result = exec.split('!')
          
          raise Sogenactif::Errors::MissingPath if result.empty? or (result[1].empty? && result[2].empty?)
          raise Sogenactif::Errors::ApiCall.new(result[1], result[2]) unless result[1].to_i == 0
          parse_result result
        end
        
        private
        #
        # Executes the binary call
        #
        def exec
          path = File.join(options[:bin_path], 'response')
          `#{path} pathfile=#{options[:filepath]} message=#{message}`
        end
        
        def parse_result(result)
          parsed = Hash.new
          result.each_index do |i|
            parsed[fields[i-1].to_sym] = result[i]
          end
          parsed
        end
        
        def fields
          ['code', 'error', 'merchant_id', 'merchant_country', 'amount', 'transaction_id', 'payment_means',
           'transmission_date', 'payment_time', 'payment_date', 'response_code', 'payment_certificate',
           'authorisation_id', 'currency_code', 'card_number', 'cvv_flag', 'cvv_response_code',
           'bank_response_code', 'complementary_code', 'complementary_info', 'return_context',
           'caddie', 'receipt_complement', 'merchant_language', 'language', 'customer_id',
           'order_id', 'customer_email', 'customer_ip_address', 'capture_day', 'capture_mode', 'data']
        end
      end
    end
  end
end

Sogenactif::Response.send(:include, Sogenactif::ResponseBinary)