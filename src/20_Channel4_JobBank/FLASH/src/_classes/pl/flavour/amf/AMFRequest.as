package pl.flavour.amf
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;		

	public class AMFRequest extends EventDispatcher {

		private var _service : AMFService;
		private var _connection : NetConnection;
		private var _responder : Responder = null;

		private var _procedure : String;
		private var _params : Array;

		private var _onSuccess : Function;
		private var _onFailure : Function;

		private var _result : Object;
		private var _errorEvent : Event;

		private var _canceled : Boolean = false;

		public function AMFRequest(service : AMFService, connection : NetConnection, procedure : String, params : Array, onSuccess : Function, onFailure : Function) 
		{
			_service = service;
			_connection = connection;
			_procedure = procedure;
			_params = params;
			_onFailure = onFailure;
			_onSuccess = onSuccess; 

			connection.addEventListener(NetStatusEvent.NET_STATUS, errorHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		} 

		public function get connection() : NetConnection 
		{
			return _connection;
		}

		public function get service() : AMFService 
		{
			return _service;
		}

		public function get responder() : Responder 
		{
			return _responder;
		}		

		public function get procedure() : String 
		{
			return _procedure;
		}

		/** 
		 * Czyste dane zwrocone przez serwer
		 */
		public function get resultData() : Object 
		{
			return _result;
		}

		/** 
		 * Event z bledem
		 */
		public function get errorEvent() : Event 
		{
			return _errorEvent;
		}

		public function isCanceled() : Boolean 
		{
			return _canceled;
		}

		/** 
		 * Czy jest odpowiedz serwera? 
		 */
		public function gotResponse() : Boolean 
		{
			return _result != null || _errorEvent != null;
		}

		/** 
		 * Czy polaczenie było nieudane?
		 */
		public function isFailed() : Boolean 
		{
			return _errorEvent != null;
		}

		/** 
		 * Czy polaczenie było nieudane, lub czy serwer zwrocil blad, lub nieprawidłowy wynik?
		 */
		public function gotError() : Boolean 
		{
			if (!gotResponse()) return false;
			return isFailed() || getErrors().length > 0 || getResult() == null;
		}

		/** 
		 * Zwraca tablice bledow ze zwrotu (errors)
		 */
		public function getErrors() : Array 
		{
			if (!gotResponse()) return null;
			return AMFService.getResultErrors(_result);
		}

		/** 
		 * Zwraca sklejona tresc bledow
		 */
		public function getErrorString(join : String = "\n") : String 
		{
			if (!gotResponse()) return null;
			return AMFService.getResultErrorsString(_result, join);
		}

		/** 
		 * Zwraca obiekt wynik ze zwrotu (result)
		 */ 
		public function getResult() : Object 
		{
			if (!gotResponse()) return null;
			return AMFService.getResult(_result);
		}
		
		/** 
		 * Zwraca tablice przekazanych argumentow do funkcji 
		 */ 
		public function getParams() : Array 
		{
			return _params;
		}		

		/** 
		 * Sprawdza czy w wyniku istnieje klucz successField i czy jest różny od 0
		 */
		public function gotSuccess(successField : String = "success") : Boolean 
		{
			if (resultData == null) return false;
			if (resultData.propertyIsEnumerable(successField) == false) return false;
			return new Number(resultData[successField]) != 0; 
		}

		public function call() : void 
		{
			if (_responder != null) {
				throw new Error("AMFRequest::call already called!");
				return; // już został wywołany!
			}
			_responder = new Responder(successHandler, errorHandler);
			var params : Array = _params.concat();
			params.unshift(procedure, _responder);
			connection.call.apply(connection, params);
		}

		/** 
		 * Anuluje zapytanie - żaden handler nie zostanie uruchomiony 
		 */
		public function cancel() : void 
		{
			_canceled = true;
		}

		private function finish() : void 
		{
			connection.removeEventListener(NetStatusEvent.NET_STATUS, errorHandler);
			connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		};

		private function successHandler(res : *) : void 
		{
			_result = res;
			
			if (_canceled == false) {
				this.dispatchEvent(new AMFEvent(this, AMFEvent.SUCCESS));
				this.service.dispatchEvent(new AMFEvent(this, AMFEvent.SUCCESS));
				if (_onSuccess != null) {
					_onSuccess(this);
				}
			}
			finish();
		};

		private function errorHandler(e : *) : void 
		{
			if (e is Event) {
				_errorEvent = e;
			} else {
				_result = e;
			}
			
			if (_canceled == false) {
				this.dispatchEvent(new AMFEvent(this, AMFEvent.ERROR));
				this.service.dispatchEvent(new AMFEvent(this, AMFEvent.ERROR));
				if (_onFailure != null) {
					_onFailure(this);
				}
			}
			finish();
		};		
	}
}
