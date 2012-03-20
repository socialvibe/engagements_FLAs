package com.socialvibe.core.services
{
	import com.socialvibe.core.config.Services;
	
	import flash.utils.*;
	
	import org.rubyamf.remoting.ssr.*;
	
	public class OAuthService
	{
		private static const SIG_METHOD:String 		= 'HMAC-SHA1';
		private static const VERSION:String			= '1.0';
		
		public static var ACCESS_TOKEN:String;
		public static var ACCESS_SECRET:String;
		
		private static var _requestURL:String;
		private static var _params:Object;
		
  		public function OAuthService():void { }

		public static function addOAuthParams(params:Object, signParams:Boolean, url:String):void
		{
			_requestURL = url;
			
			var curDate:Date = new Date();
            var uuid:String = OAuthUtils.createUID();
            
            _params = {};
            
            var params_to_use:Object = params;
            if (signParams)
            {
            	params_to_use = {};
				for (var arg:String in params)
				{
					var object:Boolean = false;					
					for (var arg2:String in params[arg])
					{
						params_to_use[arg + '[' + arg2 + ']'] = params[arg][arg2];
						object = true;
					}
					if (!object)
						params_to_use[arg] = params[arg];
				}
            }
            
            for (var param:String in params_to_use)
            {
            	_params[OAuthUtils.encode(param)] = OAuthUtils.encode(params_to_use[param]);
            }

            _params["oauth_nonce"] = uuid;
            _params["oauth_timestamp"] = curDate.time;
            _params["oauth_consumer_key"] = Services.OAUTH_CONSUMER_KEY;
            _params["oauth_signature_method"] = SIG_METHOD;
            _params["oauth_version"] = VERSION;
            if (ACCESS_TOKEN)
				_params["oauth_token"] = ACCESS_TOKEN;
			
			// generate the signature
            var signature:String = signRequest(_params);
            
            var aParams:Array = new Array();
            aParams.push('OAuth realm=""');
            aParams.push('oauth_nonce="' + uuid + '"');
            aParams.push('oauth_timestamp="' + curDate.time + '"');
            aParams.push('oauth_consumer_key="' + Services.OAUTH_CONSUMER_KEY + '"');
            aParams.push('oauth_signature_method="' + SIG_METHOD + '"');
            aParams.push('oauth_version="' + VERSION + '"');
            if (ACCESS_TOKEN)
				aParams.push('oauth_token="' + ACCESS_TOKEN + '"');
            aParams.push('oauth_signature="' + signature + '"');
            
            if (params.hasOwnProperty("oauth_nonce"))
            	delete(params.oauth_nonce);
            if (params.hasOwnProperty("oauth_timestamp"))
            	delete(params.oauth_timestamp);
            if (params.hasOwnProperty("oauth_consumer_key"))
            	delete(params.oauth_consumer_key);
			if (params.hasOwnProperty("oauth_signature_method"))
            	delete(params.oauth_signature_method);
            if (params.hasOwnProperty("oauth_version"))
            	delete(params.oauth_version);
            if (params.hasOwnProperty("oauth_token"))
            	delete(params.oauth_token);
            
            params["HTTP_AUTHORIZATION"] = aParams.join(", ");
		}
		
		private static function signRequest(params:Object):String
		{
            // get the signable string
            var toBeSigned:String = getSignableString(params);
            
            // get the secrets to encrypt with
            var sSec:String = Services.OAUTH_CONSUMER_SECRET + "&"
            if (ACCESS_SECRET)
            	sSec += ACCESS_SECRET;
            
            var hmac:HMAC = OAuthUtils.getHMAC("sha1");
            var key:ByteArray = Hex.toArray(Hex.fromString(sSec));
            var message:ByteArray = Hex.toArray(Hex.fromString(toBeSigned));

            //trace(sSec);
            trace(toBeSigned);

            var result:ByteArray = hmac.compute(key,message);
            var ret:String = Base64.encodeByteArray(result);
            //trace(ret);
           	return encodeURIComponent(ret);
            //return ret;
	    }
	    
	    private static function getSignableParameters(params:Object):String
	    {
            var aParams:Array = new Array();
            
            // loop over params, find the ones we need
            for (var param:String in params) {
            	if (param != "oauth_signature")
                	aParams.push(param + "=" + (params[param] == 'null' ? "" : params[param].toString()));
            }
            
            // put them in the right order
            aParams.sort();
            
            // return them like a querystring
            return aParams.join("&");
        }
		
		public static function getSignableString(params:Object):String
		{
            // create the string to be signed
            var ret:String = encodeURIComponent('POST');
            ret += "&";
            ret += encodeURIComponent(_requestURL);
            ret += "&";
            ret += encodeURIComponent(getSignableParameters(params));
            
            return ret;
        }
	}
}

import flash.utils.ByteArray;
import flash.utils.Endian;

class OAuthUtils
{
   	private static const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 
    	55, 56, 57, 65, 66, 67, 68, 69, 70];

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Generates a UID (unique identifier) based on ActionScript's
	 *  pseudo-random number generator and the current time.
	 *
	 *  <p>The UID has the form
	 *  <code>"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"</code>
	 *  where X is a hexadecimal digit (0-9, A-F).</p>
	 *
	 *  <p>This UID will not be truly globally unique; but it is the best
	 *  we can do without player support for UID generation.</p>
	 *
	 *  @return The newly-generated UID.
	 */
	public static function createUID():String
	{
	    var uid:Array = new Array(36);
	    var index:int = 0;
	    
	    var i:int;
	    var j:int;
	    
	    for (i = 0; i < 8; i++)
	    {
	        uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
	    }
	
	    for (i = 0; i < 3; i++)
	    {
	        uid[index++] = 45; // charCode for "-"
	        
	        for (j = 0; j < 4; j++)
	        {
	            uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
	        }
	    }
	    
	    uid[index++] = 45; // charCode for "-"
	
	    var time:Number = new Date().getTime();
	    // Note: time is the number of milliseconds since 1970,
	    // which is currently more than one trillion.
	    // We use the low 8 hex digits of this number in the UID.
	    // Just in case the system clock has been reset to
	    // Jan 1-4, 1970 (in which case this number could have only
	    // 1-7 hex digits), we pad on the left with 7 zeros
	    // before taking the low digits.
	    var timeString:String = ("0000000" + time.toString(16).toUpperCase()).substr(-8);
	    
	    for (i = 0; i < 8; i++)
	    {
	        uid[index++] = timeString.charCodeAt(i);
	    }
	    
	    for (i = 0; i < 4; i++)
	    {
	        uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
	    }
	    
	    return String.fromCharCode.apply(null, uid);
	}
	
	public static function encode(str:String):String
	{
		return encodeURIComponent(str).replace(/!/g, '%21').replace(/~/g, '%7E').replace(/\*/g, '%2A').replace(/\'/g, '%27').replace(/\(/g, '%28').replace(/\)/g, '%29');
	}
	
	public static function getHMAC(name:String):HMAC
	{
		var keys:Array = name.split("-");
		if (keys[0]=="hmac") keys.shift();
		var bits:uint = 0;
		if (keys.length>1) {
			bits = parseInt(keys[1]);
		}
		return new HMAC(new SHA1, bits);
	}
}

class HMAC
{
	private var hash:SHABase;
	private var bits:uint;
	
	/**
	 * Create a HMAC object, using a Hash function, and 
	 * optionally a number of bits to return. 
	 * The HMAC will be truncated to that size if needed.
	 */
	public function HMAC(hash:SHABase, bits:uint=0) {
		this.hash = hash;
		this.bits = bits;
	}

	public function getHashSize():uint {
		if (bits!=0) {
			return bits/8;
		} else {
			return hash.getHashSize();
		}
	}

	/**
	 * Compute a HMAC using a key and some data.
	 * It doesn't modify either, and returns a new ByteArray with the HMAC value.
	 */
	public function compute(key:ByteArray, data:ByteArray):ByteArray {
		var hashKey:ByteArray;
		if (key.length>hash.getInputSize()) {
			hashKey = hash.hash(key);
		} else {
			hashKey = new ByteArray;
			hashKey.writeBytes(key);
		}
		while (hashKey.length<hash.getInputSize()) {
			hashKey[hashKey.length]=0;
		}
		var innerKey:ByteArray = new ByteArray;
		var outerKey:ByteArray = new ByteArray;
		for (var i:uint=0;i<hashKey.length;i++) {
			innerKey[i] = hashKey[i] ^ 0x36;
			outerKey[i] = hashKey[i] ^ 0x5c;
		}
		// inner + data
		innerKey.position = hashKey.length;
		innerKey.writeBytes(data);
		var innerHash:ByteArray = hash.hash(innerKey);
		// outer + innerHash
		outerKey.position = hashKey.length;
		outerKey.writeBytes(innerHash);
		var outerHash:ByteArray = hash.hash(outerKey);
		if (bits>0 && bits<8*outerHash.length) {
			outerHash.length = bits/8;
		}
		return outerHash;
	}
	public function dispose():void {
		hash = null;
		bits = 0;
	}
	public function toString():String {
		return "hmac-"+(bits>0?bits+"-":"")+hash.toString();
	}

}

class Hex
{
	/**
	 * Support straight hex, or colon-laced hex.
	 * (that means 23:03:0e:f0, but *NOT* 23:3:e:f0)
	 * Whitespace characters are ignored.
	 */
	public static function toArray(hex:String):ByteArray {
		hex = hex.replace(/\s|:/gm,'');
		var a:ByteArray = new ByteArray;
		if (hex.length&1==1) hex="0"+hex;
		for (var i:uint=0;i<hex.length;i+=2) {
			a[i/2] = parseInt(hex.substr(i,2),16);
		}
		return a;
	}
	
	public static function fromArray(array:ByteArray, colons:Boolean=false):String {
		var s:String = "";
		for (var i:uint=0;i<array.length;i++) {
			s+=("0"+array[i].toString(16)).substr(-2,2);
			if (colons) {
				if (i<array.length-1) s+=":";
			}
		}
		return s;
	}
	
	/**
	 * 
	 * @param hex
	 * @return a UTF-8 string decoded from hex
	 * 
	 */
	public static function toString(hex:String):String {
		var a:ByteArray = toArray(hex);
		return a.readUTFBytes(a.length);
	}
	
	
	/**
	 * 
	 * @param str
	 * @return a hex string encoded from the UTF-8 string str
	 * 
	 */
	public static function fromString(str:String, colons:Boolean=false):String {
		var a:ByteArray = new ByteArray;
		a.writeUTFBytes(str);
		return fromArray(a, colons);
	}
	
}

class Base64 {
	
	private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

	public static const version:String = "1.0.0";

	public static function encode(data:String):String {
		// Convert string to ByteArray
		var bytes:ByteArray = new ByteArray();
		bytes.writeUTFBytes(data);
		
		// Return encoded ByteArray
		return encodeByteArray(bytes);
	}
	
	public static function encodeByteArray(data:ByteArray):String {
		// Initialise output
		var output:String = "";
		
		// Create data and output buffers
		var dataBuffer:Array;
		var outputBuffer:Array = new Array(4);
		
		// Rewind ByteArray
		data.position = 0;
		
		// while there are still bytes to be processed
		while (data.bytesAvailable > 0) {
			// Create new data buffer and populate next 3 bytes from data
			dataBuffer = new Array();
			for (var i:uint = 0; i < 3 && data.bytesAvailable > 0; i++) {
				dataBuffer[i] = data.readUnsignedByte();
			}
			
			// Convert to data buffer Base64 character positions and 
			// store in output buffer
			outputBuffer[0] = (dataBuffer[0] & 0xfc) >> 2;
			outputBuffer[1] = ((dataBuffer[0] & 0x03) << 4) | ((dataBuffer[1]) >> 4);
			outputBuffer[2] = ((dataBuffer[1] & 0x0f) << 2) | ((dataBuffer[2]) >> 6);
			outputBuffer[3] = dataBuffer[2] & 0x3f;
			
			// If data buffer was short (i.e not 3 characters) then set
			// end character indexes in data buffer to index of '=' symbol.
			// This is necessary because Base64 data is always a multiple of
			// 4 bytes and is basses with '=' symbols.
			for (var j:uint = dataBuffer.length; j < 3; j++) {
				outputBuffer[j + 1] = 64;
			}
			
			// Loop through output buffer and add Base64 characters to 
			// encoded data string for each character.
			for (var k:uint = 0; k < outputBuffer.length; k++) {
				output += BASE64_CHARS.charAt(outputBuffer[k]);
			}
		}
		
		// Return encoded data
		return output;
	}
	
	public static function decode(data:String):String {
		// Decode data to ByteArray
		var bytes:ByteArray = decodeToByteArray(data);
		
		// Convert to string and return
		return bytes.readUTFBytes(bytes.length);
	}
	
	public static function decodeToByteArray(data:String):ByteArray {
		// Initialise output ByteArray for decoded data
		var output:ByteArray = new ByteArray();
		
		// Create data and output buffers
		var dataBuffer:Array = new Array(4);
		var outputBuffer:Array = new Array(3);

		// While there are data bytes left to be processed
		for (var i:uint = 0; i < data.length; i += 4) {
			// Populate data buffer with position of Base64 characters for
			// next 4 bytes from encoded data
			for (var j:uint = 0; j < 4 && i + j < data.length; j++) {
				dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
			}
  			
  			// Decode data buffer back into bytes
			outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 0x30) >> 4);
			outputBuffer[1] = ((dataBuffer[1] & 0x0f) << 4) + ((dataBuffer[2] & 0x3c) >> 2);		
			outputBuffer[2] = ((dataBuffer[2] & 0x03) << 6) + dataBuffer[3];
			
			// Add all non-padded bytes in output buffer to decoded data
			for (var k:uint = 0; k < outputBuffer.length; k++) {
				if (dataBuffer[k+1] == 64) break;
				output.writeByte(outputBuffer[k]);
			}
		}
		
		// Rewind decoded data ByteArray
		output.position = 0;
		
		// Return decoded data
		return output;
	}
	
	public function Base64() {
		throw new Error("Base64 class is static container only");
	}
}

class SHABase
{
	public function getInputSize():uint
	{
		return 64;
	}
	
	public function getHashSize():uint
	{
		return 0;
	}
	
	public function hash(src:ByteArray):ByteArray
	{
		var savedLength:uint = src.length;
		var savedEndian:String = src.endian;
		
		src.endian = Endian.BIG_ENDIAN;
		var len:uint = savedLength *8;
		// pad to nearest int.
		while (src.length%4!=0) {
			src[src.length]=0;
		}
		// convert ByteArray to an array of uint
		src.position=0;
		var a:Array = [];
		for (var i:uint=0;i<src.length;i+=4) {
			a.push(src.readUnsignedInt());
		}
		var h:Array = core(a, len);
		var out:ByteArray = new ByteArray;
		var words:uint = getHashSize()/4;
		for (i=0;i<words;i++) {
			out.writeUnsignedInt(h[i]);
		}
		// unpad, to leave the source untouched.
		src.length = savedLength;
		src.endian = savedEndian;
		return out;
	}
	protected function core(x:Array, len:uint):Array {
		return null;
	}
	
	public function toString():String {
		return "sha";
	}
}

class SHA1 extends SHABase
{
	public static const HASH_SIZE:int = 20;
	
	public override function getHashSize():uint {
		return HASH_SIZE;
	}
	
	protected override function core(x:Array, len:uint):Array
	{
	  /* append padding */
	  x[len >> 5] |= 0x80 << (24 - len % 32);
	  x[((len + 64 >> 9) << 4) + 15] = len;
	
	  var w:Array = [];
	  var a:uint =  0x67452301; //1732584193;
	  var b:uint = 0xEFCDAB89; //-271733879;
	  var c:uint = 0x98BADCFE; //-1732584194;
	  var d:uint = 0x10325476; //271733878;
	  var e:uint = 0xC3D2E1F0; //-1009589776;
	
	  for(var i:uint = 0; i < x.length; i += 16)
	  {
	  	
	    var olda:uint = a;
	    var oldb:uint = b;
	    var oldc:uint = c;
	    var oldd:uint = d;
	    var olde:uint = e;
	
	    for(var j:uint = 0; j < 80; j++)
	    {
	      if (j < 16) {
	      	w[j] = x[i + j] || 0;
	      } else {
	      	w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
	      }
	      var t:uint = rol(a,5) + ft(j,b,c,d) + e + w[j] + kt(j);
	      e = d;
	      d = c;
	      c = rol(b, 30);
	      b = a;
	      a = t;
	    }
		a += olda;
		b += oldb;
		c += oldc;
		d += oldd;
		e += olde;
	  }
	  return [ a, b, c, d, e ];
	
	}
	
	/*
	 * Bitwise rotate a 32-bit number to the left.
	 */
	private function rol(num:uint, cnt:uint):uint
	{
	  return (num << cnt) | (num >>> (32 - cnt));
	}
	
	/*
	 * Perform the appropriate triplet combination function for the current
	 * iteration
	 */
	private function ft(t:uint, b:uint, c:uint, d:uint):uint
	{
	  if(t < 20) return (b & c) | ((~b) & d);
	  if(t < 40) return b ^ c ^ d;
	  if(t < 60) return (b & c) | (b & d) | (c & d);
	  return b ^ c ^ d;
	}
	
	/*
	 * Determine the appropriate additive constant for the current iteration
	 */
	private function kt(t:uint):uint
	{
	  return (t < 20) ? 0x5A827999 : (t < 40) ?  0x6ED9EBA1 :
	         (t < 60) ? 0x8F1BBCDC : 0xCA62C1D6;
	}
	public override function toString():String {
		return "sha1";
	}
}