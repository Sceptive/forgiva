require 'forgiva'
require 'testvectors'
require 'openssl'
require 'constants'

class ForgivaTest


  def self.run_tests


      TestVectors::FA_TESTS.each do |test_vec|

        puts "#{Constants::COLOR_GRN} Testing algorithm #{test_vec[:algorithm_name]} ... #{Constants::COLOR_RST}"

        plain_data = [test_vec[:data_hex]].pack('H*')
        key = [test_vec[:key_hex]].pack('H*')
        iv = [test_vec[:iv_hex]].pack('H*')
        expected = [test_vec[:target_hex]].pack('H*')

        if (test_vec[:is_encryption_algorithm]) then
          result = Forgiva.encrypt_ex(test_vec[:algorithm_name], plain_data, key, iv)

        else
          result = Forgiva.hash(test_vec[:algorithm_name],plain_data)
        end

        if (result != expected) then
          puts "#{Constants::COLOR_RED} FAILED: (Expected: #{test_vec[:target_hex]}) #{result.unpack('H*') if result != nil} #{Constants::COLOR_RST}"
        end

      end


      TestVectors::FG_TESTS.each do |test_vec|

        for i in 0..1 do
          puts "#{Constants::COLOR_GRN} Testing forgiva #{Constants::COLOR_BLU} #{test_vec[:host]}  " \
          <<"/ #{test_vec[:account]} / #{test_vec[:renewal_date]} /  #{Constants::COLOR_MGN} #{test_vec[:animal_name]} #{Constants::COLOR_GRN} " \
          <<" on complexity #{test_vec[:complexity]} #{Constants::COLOR_RST}" \
          <<"#{Constants::COLOR_YEL}" \
          << (i == 1 ? "+SCRYPT" : "") \
          << "#{Constants::COLOR_RST}"

          p_hash = OpenSSL::Digest.digest("sha512",test_vec[:master_key])

          passes = Forgiva.new(test_vec[:host],
          test_vec[:account],
          test_vec[:renewal_date],
          p_hash,
          test_vec[:complexity],
          16,
          i == 1
          ).passwords

          g_pass = passes[test_vec[:animal_name]].unpack('H*')[0]

          expected = (i == 0 ? test_vec[:expected_password_hash] : test_vec[:expected_password_hash_scrypt])

          if (g_pass.downcase != expected) then
              puts "#{Constants::COLOR_RED}  FAILED: (Expected: #{expected}) #{Constants::COLOR_RST} #{g_pass}"
          else
              puts "#{Constants::COLOR_GRN}! SUCCESS: (#{g_pass}) #{Constants::COLOR_RST}"
          end
        end
        

      end


  end


end
