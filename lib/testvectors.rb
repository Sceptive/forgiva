require 'constants'


module TestVectors
  FG_TESTS = [
    {:host => "facebook.com",
    :account => "bill.gates@microsoft.com",
    :renewal_date => "1970-01-01",
    :master_key => "forgiva_rockz_all_the_fuck1ng_t1m3",
    :complexity => Constants::FORGIVA_PG_SIMPLE,
    :animal_name => "Ape",
    :expected_password_hash => "797036592a475f78444c6153504d3757"},

    ## facebook.com - root
    {:host => "facebook.com",
     :account => "root",
     :renewal_date => "1970-01-01",
     :master_key => "forgiva_rockz_all_the_fuck1ng_t1m3",
     :complexity => Constants::FORGIVA_PG_INTERMEDIATE,
     :animal_name => "Bat",
     :expected_password_hash => "5544245f2b72682e4635765040416a49"

    },

    ## facebook.com - k3ym4k3r
    {:host => "facebook.com",
      :account => "k3ym4k3r",
      :renewal_date => "1970-01-01",
      :master_key => "forgiva_rockz_all_the_fuck1ng_t1m3",
      :complexity => Constants::FORGIVA_PG_ADVANCED,
      :animal_name => "Bear",
      :expected_password_hash => "4f5c7653513251417a675949284c5539"

    },

    ## facebook.com - scr1ptk1dd1e
    {:host => "facebook.com",
       :account => "scr1ptk1dd1e",
       :renewal_date => "1970-01-01",
       :master_key => "forgiva_rockz_all_the_fuck1ng_t1m3",
       :complexity => Constants::FORGIVA_PG_SIMPLE,
       :animal_name => "Whale",
       :expected_password_hash => "6465635a675374322f47695051464157"
      },

    ## microsoft.com - toor
    {:host => "microsoft.com",
     :account => "toor",
     :renewal_date => "1970-01-01",
     :master_key => "forgiva_rockz_all_the_fuck1ng_t1m3",
     :complexity => Constants::FORGIVA_PG_INTERMEDIATE,
     :animal_name => "Crow",
     :expected_password_hash => "4d314573586d403649672970786d7133"
    },

    ## 192.168.0.1 - root
    {:host => "192.168.0.1",
      :account => "root",
      :renewal_date => "1970-01-01",
      :master_key => "forgiva_rockz_all_the_fuck1ng_t1m3",
      :complexity => Constants::FORGIVA_PG_ADVANCED,
      :animal_name => "Dog",
      :expected_password_hash => "2c376d234a7a6c4d6f785c34494a672a"
    },

    ## 10.0.0.2:22 - root
    {:host => "10.0.0.2:22",
       :account => "root",
       :renewal_date => "1970-01-01",
       :master_key => "forgiva_rockz_all_the_fuck1ng_t1m3",
       :complexity => Constants::FORGIVA_PG_SIMPLE,
       :animal_name => "Duck",
       :expected_password_hash => "6440562a36375065693646396e312c4b"

    },

    ## 10.0.0.2:22 - k3ym4k3r
    {:host => "10.0.0.2:22",
      :account => "k3ym4k3r",
      :renewal_date => "1970-01-01",
      :master_key => "forgiva_rockz_all_the_fuck1ng_t1m3",
      :complexity => Constants::FORGIVA_PG_INTERMEDIATE,
      :animal_name => "Cat",
      :expected_password_hash => "78435f57566e2f53535f2e617738293b"

    },

    ## 10.0.0.2:22 - toor
    {:host => "10.0.0.2:22",
      :account => "toor",
      :renewal_date => "1970-01-01",
      :master_key => "forgiva_rockz_all_the_fuck1ng_t1m3",
      :complexity => Constants::FORGIVA_PG_ADVANCED,
      :animal_name => "Wasp",
      :expected_password_hash => "54534a582b265f337e2e43403b536861"
    }].freeze

    FA_TESTS = [{:is_encryption_algorithm => true,
     :algorithm_name => "camellia-128-cbc",
     :data_hex =>
         "b9717e084ce3a6bb30af116bc811df7cbfdd618c005c92c90076162daba5a849",
     :key_hex => "d40d6d81d931ecc30a534c3f9d5dfe01",
     :iv_hex => "cd5464cf4236b8a53ad5b42cbc27f0a8",
     :target_hex => "5a2e35425a955265856300246eca4e65a4a428935c80e59dffed50852b8430d0"},

    {:is_encryption_algorithm => true,
     :algorithm_name => "camellia-192-cbc",
     :data_hex =>
         "404e8c8b37e91d052ffd70573ed257a9677811cfa73458ba0607dc9e8def97b4",
     :key_hex => "edb8557b39e7e656148f850530950d8c",
     :iv_hex => "a8708092b77bd94c6b1f0b8cf6b0afd8",
     :target_hex => "9b297587c3291ddc538ca02cdcd46476f60d45dcf655ebb4d1f7f072d1c514f7"},

    {:is_encryption_algorithm => true,
     :algorithm_name => "camellia-256-cbc",
     :data_hex =>
         "f266dad6764640de2e13902fb7c04fcd7f1c2e950ceb1b6559d1e620ea2cf39b",
     :key_hex => "4200c4cad8b47814a5ed84ab0141aaeb",
     :iv_hex => "e0a054f34133aa2602db257fee1e7db1",
     :target_hex => "be84b266be13e13fc78a27c4ec86c4d7b70ecb26d8d1f6bbe247744f029eed19"},

    {:is_encryption_algorithm => true,
     :algorithm_name => "cast5-cbc",
     :data_hex =>
         "777de3b277bda18f668e3d152e820c1780355e3acd3c840b21f012dd5746c033",
     :key_hex => "896f94494198b4867715bfe43a85678a",
     :iv_hex => "164cc12f57553024cf070a9bfe6e9d2e",
     :target_hex => "a302710f9e7baf1ce2b77a341db04ce1defb1ef60b3e0cf77b265f877f4acbe8"},

    {:is_encryption_algorithm => true,
     :algorithm_name => "bf-cbc",
     :data_hex =>
         "d487857248f982686da2f4f2089ed190e682e0e9121f60ed5e8e5be9ac5ef899",
     :key_hex => "bfb9ed5fb23e17e59d930d25eb530a2c",
     :iv_hex => "5a112824d6ae4d9fef511706ec5c68eb",
     :target_hex => "8544fe775bd28d691ae13c4083ab43b0c0b84062cade9b166b516dbd65685263"},

    {:is_encryption_algorithm => true,
     :algorithm_name => "aes-128-cbc",
     :data_hex =>
         "63e319d3fb7f655479be7b4a1ef03853c590bda498514ce2a4810fe77bb85aa8aa",
     :key_hex => "117063a80532b561a8e9a5fc8d850365",
     :iv_hex => "13b6cd9b3c664b0d573fbced0c331040",
     :target_hex => "f8102b04449eb1ce0048c67496cce3e3a8f1cdb8238d661caddd7ad7d0af2aa920b7d5f224ae50a492e2534a729ca1eb"},

    {:is_encryption_algorithm => true,
     :algorithm_name => "aes-192-cbc",
     :data_hex =>
         "ad67bfaeadab3c6500cbb59a3995a489b131c371bd20c4a55bfe3d7408d6d84b",
     :key_hex => "dbab5fe55cd0f37e33e4b875d861ceb3",
     :iv_hex => "98044a639fcec92837b300394a709f2c",
     :target_hex => "5e439780e5f56b92911e6e60e7ce74b6c5a71cb197d77d99c0e931600c918c03"},

    {:is_encryption_algorithm => true,
     :algorithm_name => "aes-256-cbc",
     :data_hex =>
         "344e7b462a97d48431d68d315dea1a8b8fcfbe3d73a819471309597127aef5da",
     :key_hex => "24545749f13f8fb477c7d5046f490dcc",
     :iv_hex => "a5276092d0645616bf8999d744580515",
     :target_hex => "c60682324e2b83886e17432c212d6690d44afb465a201055af151b44a3448068"},

    {:is_encryption_algorithm => false,
     :algorithm_name => "sha512",
     :data_hex =>
         "695904cb6bf6b74ab18852f70750139d78dbf7d46dda70ce67afac1de89fd2dd",
     :key_hex => "",
     :iv_hex => "",
     :target_hex => "390e9d9c2a5483695a3707b509cd5a5948dea7221e5c3293b0a4eb4dc3c068811b27eef66adf569e268b2779cb77e35ee030918b7f3364e1882b2d524a96846c"},

    {:is_encryption_algorithm => false,
     :algorithm_name => "sha384",
     :data_hex =>
         "de9beb10c8d4208fc23eaeeda614fa6ecf8811e36d61fca957546c7649e561c1",
     :key_hex => "",
     :iv_hex => "",
     :target_hex => "dbab1b89b069043585eeb67fdae2683ec1f5a2d4e721400a3b2335228f49444fb4a0e0509a55d28ffdc608db0bf8866e"},

    {:is_encryption_algorithm => false,
     :algorithm_name => "sha256",
     :data_hex =>
         "46142ed7236f2420f4bdac45192ba954da0ea56235c03886e4a2b528d60044da",
     :key_hex => "",
     :iv_hex => "",
     :target_hex => "dccec513ea5995846df778bed02468e80ffcac06bd07d20eedbed3d367634492"},

    {:is_encryption_algorithm => false,
     :algorithm_name => "sha224",
     :data_hex =>
         "72f159ef70dee2db9e4ce0df16e19231bbacf4127ec97f430b546f838d82d173",
     :key_hex => "",
     :iv_hex => "",
     :target_hex => "0673d0dd51f915d37baf9767dc24325ab9c2317a73a9ef022aa7911c561efd65"},

    {:is_encryption_algorithm => false,
     :algorithm_name => "sha1",
     :data_hex =>
         "5bb6f36326d34827a14df430bf809a14da00c27583bd33aee91edfe58b24708a",
     :key_hex => "",
     :iv_hex => "",
     :target_hex => "f0ceb2b738be458cc0519e7a8b02c6c5cdc1c773687e1f6fb36642e2b87bfeca"},

    {:is_encryption_algorithm => false,
     :algorithm_name => "sha",
     :data_hex =>
         "a8f11175865f3f4dc543f558c282ec9b7b439bf818a77000adc9dee2199d43f5",
     :key_hex => "",
     :iv_hex => "",
     :target_hex => "47e73858d52f91a9f5a3c798d8903a759834fb955544d01deaf55e1fc380e861"},

    {:is_encryption_algorithm => false,
     :algorithm_name => "md5",
     :data_hex =>
         "1b6bc2af8a57ccf15339f023863d35e5f35d13127622e2d03e008eb78188f772",
     :key_hex => "",
     :iv_hex => "",
     :target_hex => "38806990d2b77c96d5776e3ec43cf2082d05d1de3285443444a67f984d3c2288"},

    {:is_encryption_algorithm => false,
     :algorithm_name => "md4",
     :data_hex =>
         "a64d8b2bbee2a8c820c16a14cfaea65d417decc309b3621e1bd5dc4769bb7c61",
     :key_hex => "",
     :iv_hex => "",
     :target_hex => "354fde36aeadd1816b506956985eb7b05a5f9490ae96d88c7a1b3100a8a8d2bc"},

    {:is_encryption_algorithm => false,
     :algorithm_name => "ripemd160",
     :data_hex =>
         "7c2d9f56b35109f7cfdf554f70fdbf2bbff97a2244c0677820be6b38983c90ea",
     :key_hex => "",
     :iv_hex => "",
     :target_hex => "aec3c24f17677cbeffdf1081af591aaa20e51d04e69da384bb65f1eefebbb1f5"}].freeze

end
