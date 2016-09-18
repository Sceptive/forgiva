# Algorithms, password characters, animals
module Constants

  ENC_ALGS = %w(des-ede3-cbc camellia-128-cbc camellia-192-cbc camellia-256-cbc cast5-cbc bf-cbc aes-128-cbc aes-192-cbc aes-256-cbc).freeze
  HASH_ALGS = %w(sha512 sha384 sha256 sha224 sha1 sha md5 md4 ripemd160).freeze

  LETTERS = %w(q w e r t y u i o p a s d f g h j k l z x c v b n m).freeze
  BIG_LETTERS = %w(Q W E R T Y U I O P A S D F G H J K L Z X C V B N M).freeze
  NUMBERS = %w(0 1 2 3 4 5 6 7 8 9).freeze
  SPECIAL_CHARS = %w(. @ + - * / % _ ! ,).freeze

  INTERMEDIATE_CHARS = %w(| # $ ; \\ ( ) > < " =).freeze

  ADVANCED_CHARS = %w(´ ~ £ ¢ § ^ & ± { }).freeze

  PASSWORD_CHARS = (LETTERS + BIG_LETTERS + NUMBERS + SPECIAL_CHARS).freeze

  PASSWORD_CHARS_INTERMEDIATE = (PASSWORD_CHARS + INTERMEDIATE_CHARS).freeze

  PASSWORD_CHARS_ADVANCED = (PASSWORD_CHARS_INTERMEDIATE + ADVANCED_CHARS).freeze

  ANIMALS = %w(Ape Bat Bear Whale Crow Dog Duck Cat Wasp Fox Gull Hyena Lion Panda
               Rat Shark Spider Turtle Wolf Zebra).freeze

  FORGIVA_PG_SIMPLE = 1
  FORGIVA_PG_INTERMEDIATE = 2
  FORGIVA_PG_ADVANCED = 3

  COLOR_BLK = Gem.win_platform? ? "" : "\x1b[0;30m"
  COLOR_RED = Gem.win_platform? ? "" : "\x1b[0;31m"
  COLOR_GRN = Gem.win_platform? ? "" : "\x1b[0;32m"
  COLOR_BRN = Gem.win_platform? ? "" : "\x1b[0;33m"
  COLOR_BLU = Gem.win_platform? ? "" : "\x1b[0;34m"
  COLOR_MGN = Gem.win_platform? ? "" : "\x1b[0;35m"
  COLOR_CYA = Gem.win_platform? ? "" : "\x1b[0;36m"
  COLOR_LGR = Gem.win_platform? ? "" : "\x1b[0;37m"
  COLOR_GRA = Gem.win_platform? ? "" : "\x1b[1;90m"
  COLOR_LRD = Gem.win_platform? ? "" : "\x1b[1;91m"
  COLOR_LGN = Gem.win_platform? ? "" : "\x1b[1;92m"
  COLOR_YEL = Gem.win_platform? ? "" : "\x1b[1;93m"
  COLOR_LBL = Gem.win_platform? ? "" : "\x1b[1;94m"
  COLOR_PIN = Gem.win_platform? ? "" : "\x1b[1;95m"
  COLOR_LCY = Gem.win_platform? ? "" : "\x1b[1;96m"
  COLOR_BRI = Gem.win_platform? ? "" : "\x1b[1;97m"
  COLOR_RST = Gem.win_platform? ? "" : "\x1b[0m"

  # Set true to dump password generation details
  DEBUG_OUTPUT = false




end
