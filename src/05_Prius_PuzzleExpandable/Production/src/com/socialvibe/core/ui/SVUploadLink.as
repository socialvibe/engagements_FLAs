package com.socialvibe.core.ui
{
	import com.socialvibe.core.config.*;
	import com.socialvibe.core.utils.*;
	import com.socialvibe.core.ui.controls.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;

	public class SVUploadLink extends SVLink
	{
		public static const UPLOAD_COMPLETE:String 		= 'uploadComplete';
		public static const START_UPLOAD:String 		= 'startUpload';
		public static const UPLOAD_COMPLETE_DATA:String = 'uploadCompleteData';
		
		protected var _progressWidth:Number;
		protected var _progressHeight:Number;
		protected var _progressBar:Sprite;
		
		protected var _file:FileReference;
		protected var _restoreLink:Boolean;
		protected var _setAsAvatar:Boolean;
		protected var _userId:Number;
		protected var _uploadAttempt:Number;
		
		protected var _progress:Shape;
		protected var _uploadingText:SVText;
		protected var _errorMsg:SVText;
		
		public function SVUploadLink(text:String, x:Number = 0, y:Number = 0, size:Number = 11, bold:Boolean = true, 
			textColor:uint = 0xFFFFFF, hoverColor:uint = 0xFFFFFF)
		{
			super(text, x, y, size, bold, textColor, hoverColor);
			
			_progressBar = new Sprite();
			_progress = new Shape();
			_progressBar.addChild(_progress);
			
			this.addEventListener(MouseEvent.CLICK, onBrowse, false, 0, true);
		}
		
		public function configUpload(x:Number, y:Number, w:Number, h:Number, userId:Number, setAsAvatar:Boolean = false, restoreLink:Boolean = true):void
		{
			_progressWidth = w;
			_progressHeight = h;
			
			_progressBar.x = x;
			_progressBar.y = y;
			
			_restoreLink = restoreLink;
			
			_userId = userId;
			_setAsAvatar = setAsAvatar;
		}
		
		protected function showUploadError(err:String):void
		{
			removeProgress();
			addChild(_linkField);
			
			if (_errorMsg == null)
			{
				_errorMsg = new SVText(err, _progressBar.x, _progressBar.y+_progressHeight, 10, true, Style.errorRed, _progressWidth);
				_errorMsg.autoSize = TextFieldAutoSize.CENTER;
				addChild(_errorMsg);
			}
			else
			{
				_errorMsg.text = err;
			}
		}
		
		public function onBrowse(e:Event):void
		{
			var imageFilter:FileFilter = new FileFilter("Image Files (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg; *.jpeg; *.gif; *.png");
			_file = new FileReference();
			_file.addEventListener(Event.SELECT, selectHandler, false, 0, true);
	        _file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
	        _file.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
	        _file.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
	        _file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteData, false, 0, true);
			_file.browse(new Array(imageFilter));
		}
		protected function selectHandler(event:Event):void
        {
			try
			{
				if (!_file || !_file.size)
				{
					showUploadError('Invalid image file, please try another.');
	        		return;
				}
			} catch (error:Error) {
				showUploadError('Invalid image file, please try another.');
        		return;
			}
        	
        	if (_file.size > 5242880) // 5 megabytes
        	{
        		showUploadError('Filesize too large [maximum: 5 megs]');
        		return;
        	}
        	
        	removeChild(_linkField);
        	createProgressBar();
            
            _uploadAttempt = 0;
            performUpload();
            
            dispatchEvent(new Event( START_UPLOAD, true ));
        }
        
        protected function performUpload():void
        {
        	var uploadURL:URLRequest = new URLRequest();
        	uploadURL.url = Services.SERVICES_URL + "/user_photos?user_id=" + _userId + (_setAsAvatar ? "&set_as_avatar=1" : "");
            _file.upload(uploadURL);
            _uploadAttempt += 1;
        }
        
        protected function ioErrorHandler(event:IOErrorEvent):void
        {
        	if (_uploadAttempt <= 5)
        	{
        		trace("UPLOAD ERROR::: retry attempt # : " + _uploadAttempt);
        		setTimeout(performUpload, (1000*_uploadAttempt));
        	}
        	else
        	{
        		showUploadError("Upload error, please try again.");
        	}
        }
        
        protected function progressHandler(e:ProgressEvent):void
        {
        	setProgress(e.bytesLoaded/e.bytesTotal);
        }

		protected function completeHandler(event:Event):void
		{
			dispatchEvent(new Event( UPLOAD_COMPLETE, true ));
			
        	setProgress(1.2);
        	
        	if (_progressBar && contains(_progressBar))
	        	setTimeout(removeChild, 300, _progressBar);
			if (_restoreLink)
        		setTimeout(addChild, 500, _linkField);
        }
        
        protected function uploadCompleteData(e:DataEvent):void
	    {
	    	var photoData:XML = XML(e.data);
	    	
	    	dispatchEvent(new SVEvent( UPLOAD_COMPLETE_DATA, {id:photoData.id, url:photoData.public_filename}, true ));
	    }
	    
        protected function createProgressBar():void
		{
			if (_linkField && contains(_linkField))
				removeChild(_linkField);
			
			addChild(_progressBar);
			var g:Graphics = _progressBar.graphics;
			g.clear();
			
			g.beginFill(0xFFFFFF, 0.15);
			g.drawRoundRect(0, 0, _progressWidth, _progressHeight, _progressHeight/1.5);
			g.drawRoundRect(2, 2, _progressWidth-4, _progressHeight-4, (_progressHeight/1.5)*0.85);
			
			_progress.graphics.clear();
			
			if (_uploadingText && _progressBar.contains(_uploadingText))
				_progressBar.removeChild(_uploadingText);
			
			_uploadingText = new SVText('Uploading', 0, 3, 11, false, 0xFFFFFF, _progressWidth);
			_uploadingText.autoSize = TextFieldAutoSize.CENTER;
			_progressBar.addChild(_uploadingText);
		}
		
		protected function setProgress(percent:Number):void
        {
        	var g:Graphics = _progress.graphics;
        	g.clear();
        	
        	var matr:Matrix = new Matrix();
			matr.createGradientBox(_progressWidth-4, _progressHeight-4, Math.PI/2, 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0xb0d37f, 0x7fb534], [1, 0.7], [0, 250], matr, SpreadMethod.PAD, InterpolationMethod.RGB);
			g.drawRoundRect(2, 2, Math.ceil((_progressWidth-4)*(0.83333333*percent)), _progressHeight-4, (_progressHeight/1.5)*0.85);
        }
        
        protected function removeProgress():void
        {
        	if (_progressBar && contains(_progressBar))
			{
				removeChild(_progressBar);
				addChild(_linkField);
			}
        }
	}
}