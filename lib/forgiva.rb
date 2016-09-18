#!/usr/bin/ruby
require 'openssl'
require 'highline/import'
require 'constants'

# Password generation from 4 inputs
class Forgiva
  attr_accessor :hostname, :account, :renewal_date, :master_password, :complexity, :length

  def initialize(hostname, account, renewal_date, master_password, complexity, length)
    @hostname = hostname
    @account = account
    @renewal_date = renewal_date
    @master_password = master_password
    @complexity = complexity
    @length = length
  end

  def passwords
    @passwords ||= generate
  end



  def generate
    passwords  = {}

    # Getting input data as encrypted as salt
    salt = encrypted_inputs

    puts "SALT: #{salt.unpack('H*')}" if Constants::DEBUG_OUTPUT

    # Getting master password as already hashed SHA512
    key = master_password

    puts "CLEAR KEY: #{key.unpack('H*')}"  if Constants::DEBUG_OUTPUT

    # If we have complexity options, then we overrun key
    # with the pbkdf2 hmac sha256 or sha512 algorithms
    if (@complexity == 2 || @complexity == 3) then
      key = Forgiva.pbkdf2_hmac_sha(key,salt,@complexity)
    end

    puts "ENC KEY: #{key.unpack('H*')}"  if Constants::DEBUG_OUTPUT


    Constants::ANIMALS.each do |a|
      # For every other animal we re-run pbkdf2 hmac with sha1 over key
      key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(key, salt, 10_000, 32)

      puts "GEN_KEY: #{key.unpack('H*')}"  if Constants::DEBUG_OUTPUT

      passwords[a] = Forgiva.hash_to_password(key,@complexity, @length)
    end

    passwords
  end

  def hashed_hostname
    Forgiva.hash_twice(hostname)
  end

  def hashed_account
    Forgiva.hash_twice(account)
  end

  def hashed_renewal_date
    Forgiva.hash_twice(renewal_date)
  end

  def hashed_master_password
    Forgiva.hash_twice(master_password)
  end

  def encrypted_inputs


    puts "hashed_hostname: #{hashed_hostname.unpack('H*')}" if Constants::DEBUG_OUTPUT
    puts "hashed_account:  #{hashed_account.unpack('H*')}" if Constants::DEBUG_OUTPUT

    # Encrypt iteratively hostname and account and master_password
    encrypt01 = Forgiva.iterative_encrypt(Forgiva.iterative_encrypt(hashed_hostname, hashed_account),
                                          hashed_master_password)

    puts "encrypt01:  #{encrypt01.unpack('H*')}" if Constants::DEBUG_OUTPUT

    puts "hashed_renewal_date:  #{hashed_renewal_date.unpack('H*')}" if Constants::DEBUG_OUTPUT
    puts "hashed_master_password:  #{hashed_master_password.unpack('H*')}" if Constants::DEBUG_OUTPUT

    # Encrypt iteratively renewal date and master key
    encrypt02 = Forgiva.iterative_encrypt(hashed_renewal_date, hashed_master_password)

    puts "encrypt02:  #{encrypt02.unpack('H*')}" if Constants::DEBUG_OUTPUT

    # Encrypt iteratively prior generated values
    ret = Forgiva.iterative_encrypt(
      encrypt01,
      encrypt02)

    puts "forgiva_encrypted_inputs:  #{ret.unpack('H*')}" if Constants::DEBUG_OUTPUT

    return ret
  end



  #################
  # Class methods #
  #################
  def self.pbkdf2_hmac_sha(key,salt,type)

    rkey = nil

    if (type == Constants::FORGIVA_PG_SIMPLE) then
        rkey = OpenSSL::PKCS5.pbkdf2_hmac_sha1(key, salt, 10_000, 32)
    elsif (type == Constants::FORGIVA_PG_INTERMEDIATE) then
        digest = OpenSSL::Digest::SHA256.new
        rkey = OpenSSL::PKCS5.pbkdf2_hmac(key,salt,10_000 * 1000, 32,digest);
    elsif (type == Constants::FORGIVA_PG_ADVANCED) then
      digest = OpenSSL::Digest::SHA512.new
      rkey = OpenSSL::PKCS5.pbkdf2_hmac(key,salt,10_000 * 10000, 32,digest);
    end

    return rkey
  end

  def self.pad_with_zeroes(data,block_size)

    if (data.length % block_size != 0) then

      tot = block_size + data.length

      toadd = (tot - (tot % block_size) - data.length)

      for i in (1..toadd) do
        data = data + "\x00"
      end

    end

    data
  end

  def self.shorten_if_long(data,block_size)

    data = data[0..block_size] if data.length > block_size

    data
  end

  def self.encrypt_ex(alg, data, key,iv)

    cipher = OpenSSL::Cipher::Cipher.new(alg)
    cipher.encrypt

    key_ = shorten_if_long(pad_with_zeroes(key,cipher.key_len),cipher.key_len)
    iv_ = shorten_if_long(pad_with_zeroes(iv,cipher.iv_len),cipher.iv_len)

    cipher.key = key_
    cipher.iv = iv_

    ## Padding if length is not multiple of block size of cipher
    data = pad_with_zeroes(data,cipher.block_size)

    puts "self.encrypt: #{alg} - #{data.unpack('H*')} Key: #{cipher.key_len} #{key_.unpack('H*')} IV: #{cipher.iv_len} #{iv_.unpack('H*')}" if Constants::DEBUG_OUTPUT


    ret = cipher.update(data)

    #+ cipher.final

    puts "self.encrypt: (ret) #{ret.unpack('H*')}" if Constants::DEBUG_OUTPUT

    return ret


    rescue OpenSSL::Cipher::CipherError => e
      puts "Error: #{e.message} data_len #{data.length} key_len #{key.length} iv_len #{iv.length}"
  end

  def self.encrypt(alg, data, extension)

    return self.encrypt_ex(alg,
                            data,
                            self.pbkdf2_hmac_sha(extension,'forgiva', Constants::FORGIVA_PG_SIMPLE),
                            sha512ize(extension))
  end

  def self.iterative_encrypt(val1, val2)
    ret = val1

    val1.each_byte do |c|
      alg = Constants::ENC_ALGS[c % Constants::ENC_ALGS.length]
      ret = encrypt(alg, ret, val2)
    end


    puts "#{ret.unpack('H*')}" if Constants::DEBUG_OUTPUT

    ret
  end

  def self.hash(alg, val)
    dig = OpenSSL::Digest.new(alg)
    nval =val
    puts "alg: #{alg}" if (val == nil)


    ret = ""
    puts "HASH IN: #{nval.unpack('H*')}:#{nval.length} alg: #{alg} dl: #{dig.digest_length}" if Constants::DEBUG_OUTPUT

    if (dig.digest_length < val.length) then

      st = 0
      en = dig.digest_length
      while (true) do

        inblock = val[st..en-1]
        puts "INBLOCK: #{inblock.unpack('H*')}:#{inblock.length}" if Constants::DEBUG_OUTPUT
        outblock = OpenSSL::Digest.digest(alg,inblock)
        puts "OUTBLOCK: #{outblock.unpack('H*')}:#{outblock.length}" if Constants::DEBUG_OUTPUT
        ret = ret + outblock
        puts "NRET: #{ret.unpack('H*')}:#{ret.length}" if Constants::DEBUG_OUTPUT

        st = en
        break if (st >= val.length)

        en = st + dig.digest_length
        en = val.length if (en > val.length)
      end

      ret = ret[0...val.length]

    else
      ret = dig.digest(nval)
    end


    puts "HASH OUT: #{ret.unpack('H*')}:#{ret.length}" if Constants::DEBUG_OUTPUT
    return ret
  end

  def self.iterative_hash(val)
    ret = val

    val.each_byte do |c|
      alg = Constants::HASH_ALGS[c % Constants::HASH_ALGS.length]
      ret = hash(alg, ret)
    end

    ret
  end

  def self.sha512ize(val)
    hash('sha512', val)
  end

  def self.hash_twice(val)
    iterative_hash(iterative_hash(val))
  end

  def self.hash_to_password(val,complexity,length)
    ret = ''

    # to be sure it is long enough
    hashed = sha512ize(val)


    pchars = (complexity == 2 ? Constants::PASSWORD_CHARS_INTERMEDIATE :
                  (complexity == 3 ? Constants::PASSWORD_CHARS_ADVANCED : Constants::PASSWORD_CHARS))


    hashed.each_byte do |c|
      ret += pchars[c % pchars.length]
      break if ret.length >= length
    end

    ret = ret[0..length-1]

    puts "HASH_TO_PASSWORD (IN): #{val.unpack('H*')}"   if Constants::DEBUG_OUTPUT
    puts "HASH_TO_PASSWORD (HASHED): #{hashed.unpack('H*')}"   if Constants::DEBUG_OUTPUT
    puts "HASH_TO_PASSWORD (OUT): #{ret.unpack('H*')}"   if Constants::DEBUG_OUTPUT

    return ret

  end
end
