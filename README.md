Forgiva  Open Source  Edition
=============================
For more information please refer to https://www.forgiva.com

## Overview

Forgiva is a brand new password managing idea. It's developed by security
professionals to maintain and protect passwords far more better than any
other commercial solution available on the market.

* It never stores your passwords anywhere! There is nothing to crack.
* Resistant to key-loggers.
* Combines various hashing and encryption algorithms depending on your
  master-key. Thus makes very difficult to estimate an effective
  brute-force and/or dictionary attack.
* You can choose complexity depending on your paranoia level.

## Installation

```bash
$ gem install forgiva
```

## Usage

Just type `forgiva` on the command line to run, and pick any password depending
on your favourite animal.

```

$ forgiva

      .-" L_    FORGIVA  (Open Source Edition)
 ;', /   ( o\   The new-age password manager
 \  ;    `' /
 ;_/"'.__.-"

Hostname: abc.com
Account: superuser
Master password:
Master password (again):
Generating...

Ape    	0en8*qxxbTopbKD_
Bat    	OJJ6+wv6*bx2wscf
Bear   	tFOAx/@aYd@a8zDG
Whale  	l/RiCiHlKz_c3+Xt
Crow   	0d4nXlk7mx,6g16H
Dog    	xdYhK.Tr,O,wSXBb
Duck   	tTGbDlVWdDJv!3Pj
Cat    	+kEWip3mU_6DhWkz
Wasp   	SGAl789+hsdoM_qD
Fox    	X0wxIXc_KdGC1z9t
Gull   	vnkEml-27mJJ1DmC
Hyena  	scpcqlNhTdpjbn.7
Lion   	TiMrSkoCjOj5wQ-+
Panda  	iDJ+fkJDiv,8y+-h
Rat    	map_sqAjAucsDsPh
Shark  	n1*-a4.BzPbAugUP
Spider 	Iuw6T%4qDVQyRiZh
Turtle 	PndQxbYFm0%HsCNf
Wolf   	Q%eLIONHqscny7on
Zebra  	VQRD!27jVnVSpC.E
```

Command line options:

```
forgiva [-h HOST] [-a ACCOUNT-ID] [-l LENGTH] [-s] [-c [1-3]] [-e] [OPTION...]

Help Options:
       	-?, --help                       Show help options

Application Options:
       	-h, --host-name=HOST             Host/Web Site/Domain name (e.g.: facebook.com)
       	-a, --account=ACCOUNT-ID         Account id to log-in to host such as such as e-mail address or nick-name etc.
       	-r, --renewal-date=DATE       Date for passwords to generate
       	-l, --length=LENGTH              Password length (Default: 16)
       	-s, --save-credentials           Save host name and account to local database to remember next time
       	-c, --complexity=C_LEVEL         0-3 complexity level of password generation. (Default: 0)
       	-e, --select-credentials         Select host and account info from saved list of credentials. If just host or account specified then you get filtered credentials.
       	-t, --test                       Runs core tests for the algorithm
       	-p, --scrypt                     Use scrypt algorithm to strengthen algorithm
```

## Release notes

	- 1.0.1.3 and 1.0.1.4
		- Added scrypt support with -p/--scrypt option
		- Fixed various parameter parsing bugs

## Algorithm

(Note: After 1.0.1.4 version, SCrypt support added)

Forgiva uses following digest and encryption algorithm to complex password
generation phases:

for encryption;

[des-ede3-cbc](https://en.wikipedia.org/wiki/Triple_DES) c[amellia-128-cbc camellia-192-cbc camellia-256-cbc](https://en.wikipedia.org/wiki/Camellia_(cipher)) [cast5-cbc](https://en.wikipedia.org/wiki/CAST-128)
[bf-cbc](https://en.wikipedia.org/wiki/Blowfish_(cipher)) [aes-128-cbc aes-192-cbc aes-256-cbc](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)

for hashing;

[sha512 sha384 sha256 sha224](https://en.wikipedia.org/wiki/SHA-2) [sha1](https://en.wikipedia.org/wiki/SHA-1) [sha](https://en.wikipedia.org/wiki/SHA-1#SHA-0) [md5](https://en.wikipedia.org/wiki/MD5) [md4](https://en.wikipedia.org/wiki/MD4) [ripemd160](https://en.wikipedia.org/wiki/RIPEMD)

Depending on data provided by the user Forgiva may or may not use all the encryption and hashing algorithms in an password re-generation process.

Algorithm uses 4 key data to generate password(s);

* Host (ex. google.com/facebook.com/192.168.0.1 etc.)
* Account (ex. root/abc@mail.com etc.)
* Renewal date
* Master key (SHA512 hash value of user entered key)


### Basic Algorithms

##### A. Hashing

Forgiva generates hashes by keeping key-space stable. n-bits of data gets hashed to n-bits of data by dividing data into hash-size.

```
algorithm forgiva-hashing
	Input: Value to get hashed as DATA, Hashing algorithm HALG
	Output: Hashed input data
	if HALG.hash-size < data-size
	    start_index = 0
	    end_index = HALG.hash-size
	    while start_index < DATA size
	    	input_block = DATA content from start_index to end_index
	    	output_block = HALG.hash(input_block)
	    	result = result appended output_block
	    	start_index = end_index
	    	end_index = start_index + HALG.hash-size
	    return result with the same size of DATA
	else
		return ALG.hash(DATA)
```
##### B. Iterative Hashing

Resembles hashing a value with various algorithms which are chosen by the characters of the value. Before getting into algorithm it must be understood that hashing algorithms are contained in an array and gets chosen by index number of it.

```
algorithm forgiva-iterative-hashing
	Input: Value to hashed as DATA, Algorithm array AARRAY
	Ouput: Hashed input data
	final_value = DATA
	for each character C in DATA
	     algorithm = AARRAY index of (C code num modulus AARRAY)
		 final_value = forgiva-hash(final_value, algorithm)
	return final_value
```

##### C. Encrypting

Encryption process with Forgiva is totally same with the algorithms except;

* Data block sizes gets fit into algorithm block sizes by padding zeroes or shortening.
* Encryption key gets put into PBKDF2_HMAC_SHA1 algorithm with 10_000 iteration and initialization vector (IV) is set as 'SHA512' value of encryption key.


##### D. Iterative Encryption

It's totaly same iteration-method used iterative hashing by using encryption algorithm array. As a different approach there is two input data and one will be used data to get encrypted and the other one will be used as key.


```
algorithm forgiva-iterative-encryption
	Input: Value to get encrypted as DATA, Value to used in encryption as DATA2, Algorithm array AARRAY
	Ouput: Encrypted input data
	final_value = DATA
	for each character C in DATA
	     algorithm = AARRAY index of (C code num modulus AARRAY size)
		 final_value = forgiva-encrypt(algorithm,final_value,DATA2)
	return final_value
```
### Password generation process


#### 1. Iterative hashing

Host, Account, Renewal Date and Master key gets into **forgiva-iterative-hashing** algorithm twice.

```
	Output: Hashed Host -> HHOST
			Hashed Account -> HACCOUNT
			Hashed Renewal Date -> HRDATE
			Hashed Master Key -> HMKEY
```

#### 2. Iterative encryption

Hashed datas gets into **forgiva-iterative-encryption** process as pairs and finally whole encryption phase reduces into one result.

```
	algorithm forgiva-encrypted-inputs
		Input: Hashed Host as HHOST, Hashed Account HACCOUNT, Hashed Renewal Date HRDATE, Hashed Master Key as HMKEY
		Output: Encrypted result as DATA
		first_pair_pre = forgiva-iterative-encryption(HHOST, HACCOUNT)
		first_pair = forgiva-iterative-encryption(first_pair_pre, HMKEY)
		second_pair = forgiva-iterative-encryption(HRDATE,HMKEY)
		return forgiva-iterative-encryption(first_pair,second_pair)
```

#### 3. Password derivation

Forgiva uses PBKDF2-HMAC as base of the key-derivation family and uses **forgiva-encypted-inputs** as salt mechanism.

Depending on choices of the complexity it uses SHA1 (Normal),SHA256 (Intermediate) and SHA512 (Advanced) hashing algorithms.

Note: After 1.0.1.4 Algorithm; SCrypt support added

```
	algorithm key-derivation
		Input: forgiva-encrypted-inputs as SALT, SHA512 value of master key as KEY
		Output: Array of password sized of animal count
		hash = KEY
		if scrypt_required
			hash = scrypt(hash,SALT,131072,8,1) // n = 2^7 , p=8, r=1 
		for each Animal
			hash = PBKDF2_HMAC_SHA1(hash,SALT, 10.000 iterationg with 32 bit key expectation)
			password = forgiva-hash-to-password(hash)
			push password to return animal array
```


#### 3.1. Hash to password conversion

Due to choice of complexity Forgiva uses different character-ranges to generate a good password by using hashes.


```
	algorithm hash-to-password
		Input: Hashed value as DATA, characters which will be used in password as  CHARACTER_ARRAY
		Output: 512 bit of data as KEY
		temporary_hash = SHA512(DATA)
		for each character C in temporary_hash
	    	password += CHARACTER_ARRAY index of (C code num modulus CHARACTER_ARRAY size)
	    return password

```

## Intellectual Property

Except for the components mentioned within their own copyright restrictions, the Forgiva code in this repository is copyright (c) 2016 Sceptive and under [CC BY-NC-SA 4.0 license.](https://creativecommons.org/licenses/by-nc-sa/4.0/)

## References

[1]		[PKCS #5: Password-Based Cryptography Specification Version 2.0](https://tools.ietf.org/html/rfc2898)

[2]		[US Secure Hash Algorithms (SHA and HMAC-SHA)](https://tools.ietf.org/html/rfc4634)

[3]		[HMAC: Keyed-Hashing for Message Authentication](https://tools.ietf.org/html/rfc2104)
