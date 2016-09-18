require 'forgiva'
require 'date'

# Command line access to Forgiva
class ForgivaCommands
  attr_accessor :hash_args

  def initialize(hash_args = {})
    @hash_args = hash_args
  end

  def run

    single_generate_choose if single_by_choose?
    single_generate if !single_by_choose?
  end

  def ask_for_master_password

    master_password = 'a'
    master_password_check = 'b'

    while master_password != master_password_check
      master_password  = ask(Constants::COLOR_CYA + "Master password: " + Constants::COLOR_RST ) { |q| q.echo = false }
      master_password_check  = ask(Constants::COLOR_CYA + "Master password (again): " + Constants::COLOR_RST ) { |q| q.echo = false }

      puts 'Master passwords do not match!' unless master_password == master_password_check
    end



    digest = OpenSSL::Digest.digest("sha512",master_password)

    puts "digest:  #{digest.unpack('H*')}" if Constants::DEBUG_OUTPUT
    return digest
  end


  def forgiva_r_path
    File.join(Dir.home, '.forgivacr')
  end

  def record
    line_to_add = "#{@hostname};#{@account};#{@renewal_date}"

    File.open(forgiva_r_path, 'a') do |file|
      file.puts line_to_add
    end
  end

  def saved_records
    recs = []
    i_a = 1
    File.open(forgiva_r_path).each do |line|

      begin
        recs << line.rstrip
        hostname, account, renewal_date = line.rstrip.split(';')

        puts "#{Constants::COLOR_BRI}#{i_a} - #{Constants::COLOR_BLU}#{hostname} #{Constants::COLOR_CYA} #{account} : #{Constants::COLOR_RST} #{renewal_date}"
        i_a += 1
      rescue
        puts "Invalid line in credentials file (#{forgiva_r_path}) - #{line}  "
        exit(1)
      end
    end

    recs
  end

  def single_generate_choose
    recs = saved_records

    puts('')
    idx = ask("#{Constants::COLOR_GRN}Selection: #{Constants::COLOR_RST}")

    r = recs[idx.to_i-1].split(';')

    @hostname = r[0]
    @account = r[1]
    @renewal_date = r[2]

    single_generate
  end

  def single_generate

    init_hostname
    init_account
    init_renewal_date
    init_length
    init_master_password
    init_complexity

    puts Constants::COLOR_GRN + "Generating..." + Constants::COLOR_RST
    puts ""

    record if record?

    passwords = make_passwords(@hostname, @account, @renewal_date, @master_password, @complexity, @length)

    if animals.length > 1
      Constants::ANIMALS.each { |a| puts  "#{Constants::COLOR_YEL}#{a}#{Constants::COLOR_RST}\t#{Constants::COLOR_BRI}#{passwords[a]}#{Constants::COLOR_RST}" }
    else
      puts passwords[animals[0]]
    end
  end

  def record?
    hash_args.key? 's' || hash_args.key?('save-credentials')
  end





  def single_by_choose?
    hash_args.key?('e') || hash_args.key?('select-credentials')
  end

  def init_length
    @length = 16
    @length = hash_args['l'].to_i if hash_args['l'] != nil
    @length = hash_args['length'].to_i if @length == nil && hash_args['length'] != nil
    return @length
  end

  def init_master_password
    @master_password = ask_for_master_password
    return @master_password
  end


  def init_complexity
      @complexity = Constants::FORGIVA_PG_SIMPLE
      @complexity = hash_args['c'].to_i if hash_args['c'] != nil
      @complexity = hash_args['complexity'].to_i if @complexity == nil && hash_args['complexity'] != nil

      if (@complexity == Constants::FORGIVA_PG_INTERMEDIATE) then
        puts Constants::COLOR_YEL + "\nINTERMEDIATE COMPLEXITY\n" + Constants::COLOR_RST
      elsif (@complexity == Constants::FORGIVA_PG_ADVANCED) then
        puts Constants::COLOR_RED + "\nADVANCED COMPLEXITY\n" + Constants::COLOR_RST
      end

      return @complexity
  end


  def init_hostname
    @hostname = hash_args['h'] if hash_args['h'] != nil
    @hostname = hash_args['host'] if @hostname == nil && hash_args['host'] != nil
    @hostname = ask(Constants::COLOR_GRN + "Hostname: " + Constants::COLOR_RST ) if @hostname == nil
    return @hostname
  end

  def init_account
    @account = hash_args['a'] if hash_args['a'] != nil
    @account = hash_args['account'] if hash_args['account'] != nil
    @account = ask(Constants::COLOR_GRN + "Account: " + Constants::COLOR_RST ) if @account == nil
    return @account
  end

  def init_renewal_date
    @renewal_date = "1970-01-01" #Time.now.strftime("%Y-%m-%d")
    @renewal_date = hash_args['r'] if hash_args['r'] != nil
    @renewal_date = hash_args['renewal-date'] if @hostname == nil && hash_args['renewal-date'] != nil

    begin
      Date.strptime(@renewal_date, '%Y-%m-%d')
    rescue
      puts "WARNING: Renewal date is not valid for YEAR-MONTH-DAY format but still accepted";
    end

    @renewal_date = @renewal_date.gsub(';','')

    return @renewal_date
  end

  def animals

    return Constants::ANIMALS

  end

  def make_passwords(hostname, account, renewal_date, master_password, complexity,length)
    Forgiva.new(hostname, account, renewal_date, master_password,complexity,length).passwords
  end



end
