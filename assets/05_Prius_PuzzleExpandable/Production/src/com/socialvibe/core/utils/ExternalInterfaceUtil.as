package com.socialvibe.core.utils
{
	import com.socialvibe.core.config.Services;
	
	import flash.external.ExternalInterface;
	import flash.net.*;
	
    public class ExternalInterfaceUtil
    {
        public static function addExternalEventListener( qualifiedEventName:String, callback:Function, callBackAlias:String ):void
        {
        	if (ExternalInterface.available)
        	{
	            // 1. Expose the callback function via the callBackAlias
	            ExternalInterface.addCallback( callBackAlias, callback );
	            
	            // 2. Build javascript to execute
	            var jsExecuteCallBack:String = "document.getElementsByName('" + ExternalInterface.objectID + "')[0]." + callBackAlias + "()";
	            var jsBindEvent:String = "function() { " + qualifiedEventName + "= function() { " + jsExecuteCallBack + " }; }";
	            
	            // 3. Execute the composed javascript to perform the binding of the external event to the specified callBack function
	            ExternalInterface.call( jsBindEvent );
	        }
        }
		
		public static function dispatchGAPageView(page:String):void
		{
			try
			{
				if (Services.SERVICES_URL == 'http://www.socialvibe.com')
					ExternalInterface.call("eval", "pageTracker._trackPageview('" + page + "');");
			}
			catch (e:Error) { }
		}
        
        public static function dispatchGAEvent(category:String, action:String, label:String, value:Number = NaN):void
        {
        	try
			{
				if (Services.SERVICES_URL == 'http://www.socialvibe.com')
					ExternalInterface.call("eval", "pageTracker._trackEvent('" + category + "', '" + action + "', '" + label + "'" + (isNaN(value) ? "" : ", " + value) + ");");
			}
			catch (e:Error) { }
        }
        
        public static function showEngagementIframe(type:String, query_args:String, onClose:Function, top:Number, left:Number, width:Number = 758, height:Number = 612):void
		{
        	showIframe('/s/profile/' + type + '_engagement_iframe/?' + query_args, top, left, width, height, onClose);
        }

        public static function showIframe(iframeSrc:String, top:Number, left:Number, width:Number, height:Number, onClose:Function, parentDiv:String = 'frameHolder'):void
        {
        	ExternalInterface.addCallback("closeFrame", onClose);
			
			var code:String = '';
			code += 'var iframe = document.createElement("IFRAME");';
			code += 'iframe.id = "dialogFrame";';
			code += 'iframe.src = "' + iframeSrc + '";';
			code += 'iframe.scrolling = "no";';
			code += 'iframe.frameBorder = 0;';
			code += 'iframe.width = ' + width + ';';
			code += 'iframe.height = ' + height + ';';
			code += 'iframe.style.position = "absolute";';
			code += 'iframe.style.overflow = "hidden";';
			code += 'iframe.style.top = "' + top + 'px";';
			code += 'iframe.style.left = "' + left + 'px";';
			code += 'iframe.style.zIndex = 99;';
			code += '$("#' + parentDiv + '")[0].appendChild(iframe);';
			code += 'return true;';
			
			var call:String = 'function(){ ' + code + ' }';
			//var call:String = 'function(){return SVEngage.showFrame(' + top + ', ' + left + ', ' + width + ', ' + height + ', "' + iframeSrc + '");}';
			ExternalInterface.call(call);
			
			scrollToTop();
        }
		
		public static function hideIframe():void
		{
			var call:String = 'function(){ $("#frameHolder")[0].removeChild($("#dialogFrame")[0]); return true; }';
			ExternalInterface.call(call);
		}
		
		public static function isSafari():Boolean
		{
			var browser:String = ExternalInterface.call("eval", "navigator.userAgent");
			return (browser.toLowerCase().indexOf("safari") != -1 && !ExternalInterfaceUtil.isChrome());
		}
		
		public static function isChrome():Boolean
		{
			var browser:String = ExternalInterface.call("eval", "navigator.userAgent");
			return (browser.toLowerCase().indexOf("chrome") != -1);
		}
        
        public static function scrollToTop(yOffset:Number = 0):void
        {
        	try
			{
				ExternalInterface.call("eval", "scroll(0," + yOffset + ");");
			}
			catch (e:Error) { }
        }
        
        public static function popup( url:String, name:String = '', params:String = ''):void
        {
        	try {
	        	if (isSafari())
				{
					navigateToURL(new URLRequest(url), "_new");
				}
				else
				{
					try
					{
						if (ExternalInterface.call("eval", "SVOpen.onClick('" + url + "', '" + name + "', '" + params + "');") == null)
						{
							ExternalInterface.call("eval", "window.open('" + url + "', '" + name + "', '" + params + "');");
						}
					}
					catch (e:Error)
					{
						navigateToURL(new URLRequest(url), "_new");
					}
				}
			} catch (e:Error) { }
        }
		
		public static function popunder( url:String, name:String, params:String):void
		{
			try {
				if (isSafari())
				{
					navigateToURL(new URLRequest(url), "_new");
				}
				else
				{
					try
					{
						ExternalInterface.call("eval", "newWin = window.open('" + url + "', '" + name + "', '" + params + "'); newWin.blur(); window.focus();");
					}
					catch (e:Error)
					{
						navigateToURL(new URLRequest(url), "_new");
					}
				}
			} catch (e:Error) { }
		}
		
		public static function sizedPopup(url:String, winFeatures:Object):void
		{
			if(!ExternalInterface.available || ExternalInterface.call("function() { " +
				"var winNew = window.open('" + url + "','','width=" + winFeatures.width + ",height=" + winFeatures.height + ",scrollbars=1,status=0,toolbar=0,menubar=0,location=0'); return (!winNew); }"))
			{
				var urlRequest:URLRequest = new URLRequest(url);
				navigateToURL(urlRequest, "_blank");
			}
		}
    }
}