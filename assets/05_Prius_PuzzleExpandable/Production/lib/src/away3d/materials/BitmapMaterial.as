﻿package away3d.materials
{
	import away3d.core.session.AbstractSession;
	import away3d.core.vos.FaceVO;
    import away3d.arcane;
    import away3d.cameras.lenses.*;
    import away3d.containers.*;
    import away3d.core.base.*;
    import away3d.core.clip.*;
    import away3d.core.draw.*;
    import away3d.core.math.*;
    import away3d.core.render.*;
    import away3d.core.utils.*;
    
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    
	use namespace arcane;
	
    /**
    * Basic bitmap material
    */
    public class BitmapMaterial extends LayerMaterial    {
    	/** @private */
    	arcane var _texturemapping:Matrix;
    	/** @private */
    	arcane var _view:View3D;
    	/** @private */
    	arcane var _focus:Number;
        /** @private */
    	arcane var _bitmap:BitmapData;
        /** @private */
    	arcane var _renderBitmap:BitmapData;
        /** @private */
        arcane var _bitmapDirty:Boolean;
        /** @private */
    	arcane var _colorTransform:ColorTransform;
        /** @private */
    	arcane var _colorTransformDirty:Boolean;
        /** @private */
        arcane var _blendMode:String;
        /** @private */
        arcane var _blendModeDirty:Boolean;
        /** @private */
		arcane var _red:Number = 1;
        /** @private */
		arcane var _green:Number = 1;
        /** @private */
		arcane var _blue:Number = 1;
        /** @private */
        arcane var _faceDictionary:Dictionary = new Dictionary(true);
        /** @private */
    	arcane var _zeroPoint:Point = new Point(0, 0);
        /** @private */
        arcane var _faceMaterialVO:FaceMaterialVO;
        /** @private */
        arcane var _mapping:Matrix;
        /** @private */
		arcane var _s:Shape = new Shape();
        /** @private */
		arcane var _graphics:Graphics;
        /** @private */
		arcane var _bitmapRect:Rectangle;
        /** @private */
		arcane var _sourceVO:FaceMaterialVO;
		/** @private */
        protected var _generated:Boolean;
        /** @private */
        protected var _session:AbstractSession;
        /** @private */
        protected var _startIndex:Number;
        /** @private */
        protected var _endIndex:Number;
        /** @private */
        protected var _source:Object3D;
        /** @private */
        protected var _faceVO:FaceVO;
        /** @private */
        protected var _uvs:Array;
		/** @private */
        arcane override function updateMaterial(source:Object3D, view:View3D):void
        {
        	_graphics = null;
        		
        	if (_colorTransformDirty)
        		updateColorTransform();
        		
        	if (_bitmapDirty)
        		updateRenderBitmap();
        	
        	if (_materialDirty || _blendModeDirty)
        		updateFaces(source, view);
        	
        	_blendModeDirty = false;
        }
        /** @private */
        arcane override function renderTriangle(priIndex:uint, viewSourceObject:ViewSourceObject, renderer:Renderer):void
        {
			_source = viewSourceObject.source;
			_session = renderer._session;
			_screenVertices = viewSourceObject.screenVertices;
			_screenIndices = viewSourceObject.screenIndices;
			_commands = renderer.primitiveCommands[priIndex];
        	_view = renderer._view;
			
        	_startIndex = renderer.primitiveProperties[priIndex*9];
        	_endIndex = renderer.primitiveProperties[priIndex*9+1];
			_faceVO = renderer.primitiveElements[priIndex];
			_uvs = renderer.primitiveUVs[priIndex];
			_generated = renderer.primitiveGenerated[priIndex];
			_near = _view.screenClipping.minZ;
			_mapping = getMapping(priIndex, viewSourceObject, renderer);
			
			if (precision) {
				if (_view.camera.lens is ZoomFocusLens)
            		_focus = _view.camera.focus;
            	else
            		_focus = 0;
            	
            	map.a = _mapping.a;
	            map.b = _mapping.b;
	            map.c = _mapping.c;
	            map.d = _mapping.d;
	            map.tx = _mapping.tx;
	            map.ty = _mapping.ty;
	            index = 0;
	            renderRec(_startIndex, _endIndex);
			} else {
				_session.renderTriangleBitmap(_renderBitmap, _mapping, _screenVertices, _screenIndices, _startIndex, _endIndex, smooth, repeat, _graphics);
			}
            if (debug)
                _session.renderTriangleLine(thickness, wireColor, wireAlpha, _screenVertices, _commands, _screenIndices, _startIndex, _endIndex);
				
			if(showNormals){
				
				_nn.rotate(_faceVO.face.normal, _view.cameraVarsStore.viewTransformDictionary[_source]);
				
				var index0:uint = viewSourceObject.screenIndices[renderer.primitiveProperties[priIndex*9]];
				var index1:uint = viewSourceObject.screenIndices[renderer.primitiveProperties[priIndex*9] + 1];
				var index2:uint = viewSourceObject.screenIndices[renderer.primitiveProperties[priIndex*9] + 2];
				_sv0x = (viewSourceObject.screenVertices[index0*3] + viewSourceObject.screenVertices[index1*3] + viewSourceObject.screenVertices[index2*3]) / 3;
				_sv0y = (viewSourceObject.screenVertices[index0*3 + 1] + viewSourceObject.screenVertices[index1*3 + 1] + viewSourceObject.screenVertices[index2*3 + 1]) / 3;
				 
				_sv1x = (_sv0x - (30*_nn.x));
				_sv1y = (_sv0y - (30*_nn.y));
				 
				_session.renderLine(_sv0x, _sv0y, _sv1x, _sv1y, 0, 0xFF00FF, 1);
			}
        }
		/** @private */
        arcane override function renderSprite(priIndex:uint, viewSourceObject:ViewSourceObject, renderer:Renderer):void
        {
            renderer._session.renderSpriteBitmap(_renderBitmap, smooth, priIndex, viewSourceObject, renderer);
        }
		/** @private */
        arcane override function renderLayer(priIndex:uint, viewSourceObject:ViewSourceObject, renderer:Renderer, layer:Sprite, level:int):int
        {
        	if (blendMode == BlendMode.NORMAL) {
        		_graphics = layer.graphics;
        	} else {
        		_session = renderer._session;
        		
        		_shape = _session.getShape(this, level++, layer);
	    		
	    		_shape.blendMode = _blendMode;
	    		
	    		_graphics = _shape.graphics;
        	}
    		
    		
    		renderTriangle(priIndex, viewSourceObject, renderer);
    		
    		return level;
        }
		/** @private */
        arcane override function renderBitmapLayer(priIndex:uint, viewSourceObject:ViewSourceObject, renderer:Renderer, containerRect:Rectangle, parentFaceMaterialVO:FaceMaterialVO):FaceMaterialVO
		{
			//draw the bitmap once
			renderSource(viewSourceObject.source, containerRect, new Matrix());
			
			_faceVO = renderer.primitiveElements[priIndex];
			
			//get the correct faceMaterialVO
			_faceMaterialVO = getFaceMaterialVO(_faceVO.face.faceVO);
			
			//pass on resize value
			if (parentFaceMaterialVO.resized) {
				parentFaceMaterialVO.resized = false;
				_faceMaterialVO.resized = true;
			}
			
			//pass on invtexturemapping value
			_faceMaterialVO.invtexturemapping = parentFaceMaterialVO.invtexturemapping;
			
			//check to see if face update can be skipped
			if (parentFaceMaterialVO.updated || _faceMaterialVO.invalidated || _faceMaterialVO.updated) {
				parentFaceMaterialVO.updated = false;
				
				//reset booleans
				_faceMaterialVO.invalidated = false;
				_faceMaterialVO.cleared = false;
				_faceMaterialVO.updated = true;
				
				//store a clone
				_faceMaterialVO.bitmap = parentFaceMaterialVO.bitmap.clone();
				
				//draw into faceBitmap
				_faceMaterialVO.bitmap.copyPixels(_sourceVO.bitmap, _faceVO.face.bitmapRect, _zeroPoint, null, null, true);
			}
			
			return _faceMaterialVO;
		}
		/** @private */
        arcane function getFaceMaterialVO(faceVO:FaceVO, source:Object3D = null, view:View3D = null):FaceMaterialVO
        {
        	source; view;
        	
        	//check to see if faceMaterialVO exists
        	if ((_faceMaterialVO = _faceDictionary[faceVO]))
        		return _faceMaterialVO;
        	
        	return _faceDictionary[faceVO] = new FaceMaterialVO();
        }
        
		private var index:int;		protected var _screenVertices:Array;
		protected var _screenIndices:Array;
		protected var _commands:Array;
		private var _near:Number;		private var _smooth:Boolean;
		private var _repeat:Boolean;
        private var _precision:Number;    	private var _shape:Shape;
        private var map:Matrix = new Matrix();        private var x:Number;
		private var y:Number;
        private var faz:Number;        private var fbz:Number;        private var fcz:Number;        private var mabz:Number;        private var mbcz:Number;        private var mcaz:Number;        private var mabx:Number;        private var maby:Number;        private var mbcx:Number;        private var mbcy:Number;        private var mcax:Number;        private var mcay:Number;        private var dabx:Number;        private var daby:Number;        private var dbcx:Number;        private var dbcy:Number;        private var dcax:Number;        private var dcay:Number;            private var dsab:Number;        private var dsbc:Number;        private var dsca:Number;        private var dmax:Number;        private var ai:Number;        private var ax:Number;        private var ay:Number;        private var az:Number;        private var bi:Number;        private var bx:Number;        private var by:Number;        private var bz:Number;        private var ci:Number;        private var cx:Number;        private var cy:Number;        private var cz:Number;		private var _showNormals:Boolean;
		private var _nn:Number3D = new Number3D();
		private var _sv0x:Number;
		private var _sv0y:Number;
		private var _sv1x:Number;
		private var _sv1y:Number;
        
        private function renderRec(startIndex:Number, endIndex:Number):void        {        	var a:int = _screenIndices[startIndex];            ai = a*3;            ax = _screenVertices[ai];            ay = _screenVertices[ai+1];            az = _screenVertices[ai+2];            var b:int = _screenIndices[startIndex+1];            bi = b*3;            bx = _screenVertices[bi];            by = _screenVertices[bi+1];            bz = _screenVertices[bi+2];            var c:int = _screenIndices[startIndex+2];            ci = c*3;            cx = _screenVertices[ci];            cy = _screenVertices[ci+1];            cz = _screenVertices[ci+2];                        if (!(_view.screenClipping is FrustumClipping) && !_view.screenClipping.rect(Math.min(ax, Math.min(bx, cx)), Math.min(ay, Math.min(by, cy)), Math.max(ax, Math.max(bx, cx)), Math.max(ay, Math.max(by, cy))))                return;            if ((_view.screenClipping is RectangleClipping) && (az < _near || bz < _near || cz < _near))                return;                        if (index >= 1000 || (_focus == Infinity) || (Math.max(Math.max(ax, bx), cx) - Math.min(Math.min(ax, bx), cx) < 10) || (Math.max(Math.max(ay, by), cy) - Math.min(Math.min(ay, by), cy) < 10))            {                _session.renderTriangleBitmap(_renderBitmap, map, _screenVertices, _screenIndices, startIndex, endIndex, smooth, repeat, _graphics);                if (debug)                    _session.renderTriangleLine(1, 0x00FF00, 1, _screenVertices, _commands, _screenIndices, startIndex, endIndex);                return;            }			            faz = _focus + az;            fbz = _focus + bz;            fcz = _focus + cz;			            mabz = 2 / (faz + fbz);            mbcz = 2 / (fbz + fcz);            mcaz = 2 / (fcz + faz);			            dabx = ax + bx - (mabx = (ax*faz + bx*fbz)*mabz);            daby = ay + by - (maby = (ay*faz + by*fbz)*mabz);            dbcx = bx + cx - (mbcx = (bx*fbz + cx*fcz)*mbcz);            dbcy = by + cy - (mbcy = (by*fbz + cy*fcz)*mbcz);            dcax = cx + ax - (mcax = (cx*fcz + ax*faz)*mcaz);            dcay = cy + ay - (mcay = (cy*fcz + ay*faz)*mcaz);                        dsab = (dabx*dabx + daby*daby);            dsbc = (dbcx*dbcx + dbcy*dbcy);            dsca = (dcax*dcax + dcay*dcay);			            if ((dsab <= precision) && (dsca <= precision) && (dsbc <= precision))            {                _session.renderTriangleBitmap(_renderBitmap, map, _screenVertices, _screenIndices, startIndex, endIndex, smooth, repeat, _graphics);                if (debug)                    _session.renderTriangleLine(1, 0x00FF00, 1, _screenVertices, _commands, _screenIndices, startIndex, endIndex);                return;            }			            var map_a:Number = map.a;            var map_b:Number = map.b;            var map_c:Number = map.c;            var map_d:Number = map.d;            var map_tx:Number = map.tx;            var map_ty:Number = map.ty;                        var sv1:int;            var sv2:int;            var sv3:int;                        index++;                        sv3 = _screenVertices.length/3;            _screenVertices[_screenVertices.length] = mbcx/2;            _screenVertices[_screenVertices.length] = mbcy/2;            _screenVertices[_screenVertices.length] = (bz+cz)/2;                        if ((dsab > precision) && (dsca > precision) && (dsbc > precision))            {            	index += 2;            	            	sv1 = _screenVertices.length/3;            	_screenVertices[_screenVertices.length] = mabx/2;                _screenVertices[_screenVertices.length] = maby/2;                _screenVertices[_screenVertices.length] = (az+bz)/2;                                sv2 = _screenVertices.length/3;                _screenVertices[_screenVertices.length] = mcax/2;                _screenVertices[_screenVertices.length] = mcay/2;                _screenVertices[_screenVertices.length] = (cz+az)/2;                	            _screenIndices[startIndex = _screenIndices.length] = a;                _screenIndices[_screenIndices.length] = sv1;                _screenIndices[_screenIndices.length] = sv2;                            	endIndex = _screenIndices.length;                                map.a = map_a*=2;                map.b = map_b*=2;                map.c = map_c*=2;                map.d = map_d*=2;                map.tx = map_tx*=2;                map.ty = map_ty*=2;                renderRec(startIndex, endIndex);            	            	_screenIndices[startIndex = _screenIndices.length] = sv1;                _screenIndices[_screenIndices.length] = b;                _screenIndices[_screenIndices.length] = sv3;                            	endIndex = _screenIndices.length;            	                map.a = map_a;                map.b = map_b;                map.c = map_c;                map.d = map_d;                map.tx = map_tx-1;                map.ty = map_ty;                renderRec(startIndex, endIndex);            	            	_screenIndices[startIndex = _screenIndices.length] = sv2;                _screenIndices[_screenIndices.length] = sv3;                _screenIndices[_screenIndices.length] = c;                            	endIndex = _screenIndices.length;            	                map.a = map_a;                map.b = map_b;                map.c = map_c;                map.d = map_d;                map.tx = map_tx;                map.ty = map_ty-1;                renderRec(startIndex, endIndex);            	            	_screenIndices[startIndex = _screenIndices.length] = sv3;                _screenIndices[_screenIndices.length] = sv2;                _screenIndices[_screenIndices.length] = sv1;                            	endIndex = _screenIndices.length;            	                map.a = -map_a;                map.b = -map_b;                map.c = -map_c;                map.d = -map_d;                map.tx = 1-map_tx;                map.ty = 1-map_ty;                renderRec(startIndex, endIndex);                                return;            }			            dmax = Math.max(dsab, Math.max(dsca, dsbc));            if (dsab == dmax)            {            	index++;            	            	sv1 = _screenVertices.length/3;            	_screenVertices[_screenVertices.length] = mabx/2;                _screenVertices[_screenVertices.length] = maby/2;                _screenVertices[_screenVertices.length] = (az+bz)/2;                	            _screenIndices[startIndex = _screenIndices.length] = a;                _screenIndices[_screenIndices.length] = sv1;                _screenIndices[_screenIndices.length] = c;                            	endIndex = _screenIndices.length;            	                map.a = map_a*=2;                map.c = map_c*=2;                map.tx = map_tx*=2;                renderRec(startIndex, endIndex);                	            _screenIndices[startIndex = _screenIndices.length] = sv1;                _screenIndices[_screenIndices.length] = b;                _screenIndices[_screenIndices.length] = c;                            	endIndex = _screenIndices.length;            	                map.a = map_a + map_b;                map.b = map_b;                map.c = map_c + map_d;                map.d = map_d;                map.tx = map_tx + map_ty - 1;                map.ty = map_ty;                renderRec(startIndex, endIndex);                                return;            }			            if (dsca == dmax)            {            	index++;            	                sv2 = _screenVertices.length/3;                _screenVertices[_screenVertices.length] = mcax/2;                _screenVertices[_screenVertices.length] = mcay/2;                _screenVertices[_screenVertices.length] = (cz+az)/2;                	            _screenIndices[startIndex = _screenIndices.length] = a;                _screenIndices[_screenIndices.length] = b;                _screenIndices[_screenIndices.length] = sv2;                            	endIndex = _screenIndices.length;            	                map.b = map_b*=2;                map.d = map_d*=2;                map.ty = map_ty*=2;                renderRec(startIndex, endIndex);                	            _screenIndices[startIndex = _screenIndices.length] = sv2;                _screenIndices[_screenIndices.length] = b;                _screenIndices[_screenIndices.length] = c;                            	endIndex = _screenIndices.length;            	                map.a = map_a;                map.b = map_b + map_a;                map.c = map_c;                map.d = map_d + map_c;                map.tx = map_tx;                map.ty = map_ty + map_tx - 1;                renderRec(startIndex, endIndex);                                return;            }                        _screenIndices[startIndex = _screenIndices.length] = a;            _screenIndices[_screenIndices.length] = b;            _screenIndices[_screenIndices.length] = sv3;                    	endIndex = _screenIndices.length;        	            map.a = map_a - map_b;            map.b = map_b*2;            map.c = map_c - map_d;            map.d = map_d*2;            map.tx = map_tx - map_ty;            map.ty = map_ty*2;            renderRec(startIndex, endIndex);                        _screenIndices[startIndex = _screenIndices.length] = a;            _screenIndices[_screenIndices.length] = sv3;            _screenIndices[_screenIndices.length] = c;                    	endIndex = _screenIndices.length;        	            map.a = map_a*2;            map.b = map_b - map_a;            map.c = map_c*2;            map.d = map_d - map_c;            map.tx = map_tx*2;            map.ty = map_ty - map_tx;            renderRec(startIndex, endIndex);        }
        		protected var _u0:Number;
        protected var _u1:Number;
        protected var _u2:Number;
        protected var _v0:Number;
        protected var _v1:Number;
        protected var _v2:Number;
        protected var _invtexmapping:Matrix = new Matrix();
				protected function renderSource(source:Object3D, containerRect:Rectangle, mapping:Matrix):void
		{
			//check to see if sourceDictionary exists
			if (!(_sourceVO = _faceDictionary[source]))
				_sourceVO = _faceDictionary[source] = new FaceMaterialVO();
			
			_sourceVO.resize(containerRect.width, containerRect.height);
			
			//check to see if rendering can be skipped
			if (_sourceVO.invalidated || _sourceVO.updated) {
				
				//calulate scale matrix
				mapping.scale(containerRect.width/width, containerRect.height/height);
				
				//reset booleans
				_sourceVO.invalidated = false;
				_sourceVO.cleared = false;
				_sourceVO.updated = false;
				
				//draw the bitmap
				if (mapping.a == 1 && mapping.d == 1 && mapping.b == 0 && mapping.c == 0 && mapping.tx == 0 && mapping.ty == 0) {
					//speedier version for non-transformed bitmap
					_sourceVO.bitmap.copyPixels(_bitmap, containerRect, _zeroPoint);
				}else {
					_graphics = _s.graphics;
					_graphics.clear();
					_graphics.beginBitmapFill(_bitmap, mapping, repeat, smooth);
					_graphics.drawRect(0, 0, containerRect.width, containerRect.height);
		            _graphics.endFill();
					_sourceVO.bitmap.draw(_s, null, _colorTransform, _blendMode, _sourceVO.bitmap.rect);
				}
			}
		}
		
        protected function updateFaces(source:Object3D = null, view:View3D = null):void
        {
        	source; view;
        	
        	notifyMaterialUpdate();
        	
        	for each (_faceMaterialVO in _faceDictionary)
        		if (!_faceMaterialVO.cleared)
        			_faceMaterialVO.clear();
        }
        
        protected function invalidateFaces(source:Object3D = null, view:View3D = null):void
        {
        	source; view;
        	
        	_materialDirty = true;
        	
        	for each (_faceMaterialVO in _faceDictionary)
        		_faceMaterialVO.invalidated = true;
        }
        
    	/**
    	 * Updates the colortransform object applied to the texture from the <code>color</code> and <code>alpha</code> properties.
    	 * 
    	 * @see color
    	 * @see alpha
    	 */
    	protected function updateColorTransform():void
        {
        	_colorTransformDirty = false;
			
			_bitmapDirty = true;
			_materialDirty = true;
        	
            if (_alpha == 1 && _color == 0xFFFFFF) {
                _renderBitmap = _bitmap;
                if (!_colorTransform || (!_colorTransform.redOffset && !_colorTransform.greenOffset && !_colorTransform.blueOffset)) {
                	_colorTransform = null;
                	return;
            	}
            } else if (!_colorTransform)
            	_colorTransform = new ColorTransform();
			
			_colorTransform.redMultiplier = _red;
			_colorTransform.greenMultiplier = _green;
			_colorTransform.blueMultiplier = _blue;
			_colorTransform.alphaMultiplier = _alpha;

            if (_alpha == 0) {
                _renderBitmap = null;
                return;
            }
        }
    	
        protected function transformUV(faceVO:FaceVO):Matrix
        {
            
            if (_uvs[0] == null || _uvs[1] == null || _uvs[2] == null)
                return null;

            _u0 = width * _uvs[0]._u;
            _u1 = width * _uvs[1]._u;
            _u2 = width * _uvs[2]._u;
            _v0 = height * (1 - _uvs[0]._v);
            _v1 = height * (1 - _uvs[1]._v);
            _v2 = height * (1 - _uvs[2]._v);
      
            // Fix perpendicular projections
            if ((_u0 == _u1 && _v0 == _v1) || (_u0 == _u2 && _v0 == _v2)) {
            	if (_u0 > 0.05)
                	_u0 -= 0.05;
                else
                	_u0 += 0.05;
                	
                if (_v0 > 0.07)           
                	_v0 -= 0.07;
                else
                	_v0 += 0.07;
            }
    
            if (_u2 == _u1 && _v2 == _v1) {
            	if (_u2 > 0.04)
                	_u2 -= 0.04;
                else
                	_u2 += 0.04;
                	
                if (_v2 > 0.06)           
                	_v2 -= 0.06;
                else
                	_v2 += 0.06;
            }
            
        	_invtexmapping.a = _u1 - _u0;
        	_invtexmapping.b = _v1 - _v0;
        	_invtexmapping.c = _u2 - _u0;
        	_invtexmapping.d = _v2 - _v0;
            _invtexmapping.tx = _u0;
            _invtexmapping.ty = _v0;
            
            return _invtexmapping;
        }
        
    	/**
    	 * Updates the texture bitmapData with the colortransform determined from the <code>color</code> and <code>alpha</code> properties.
    	 * 
    	 * @see color
    	 * @see alpha
    	 * @see setColorTransform()
    	 */
        protected function updateRenderBitmap():void
        {
        	_bitmapDirty = false;
        	
        	if (_colorTransform) {
	        	if (!_bitmap.transparent && _alpha != 1) {
	                _renderBitmap = new BitmapData(_bitmap.width, _bitmap.height, true);
	                _renderBitmap.draw(_bitmap);
	            } else {
	        		_renderBitmap = _bitmap.clone();
	           }
	            _renderBitmap.colorTransform(_renderBitmap.rect, _colorTransform);
	        } else {
	        	_renderBitmap = _bitmap;
	        }
	        
	        invalidateFaces();
        }
        
        /**
        * Calculates the mapping matrix required to draw the triangle texture to screen.
        * 
        * @param	tri		The data object holding all information about the triangle to be drawn.
        * @return			The required matrix object.
        */
		protected function getMapping(priIndex:uint, viewSourceObject:ViewSourceObject, renderer:Renderer):Matrix
		{
			if (_generated) {
				_texturemapping = transformUV(_faceVO).clone();
				_texturemapping.invert();
				
				return _texturemapping;
			}
			
			_faceMaterialVO = getFaceMaterialVO(_faceVO);			
			if (!_faceMaterialVO.invalidated)
				return _faceMaterialVO.texturemapping;
						_faceMaterialVO.invalidated = false;			
			_texturemapping = transformUV(_faceVO).clone();
			_texturemapping.invert();
			
			return _faceMaterialVO.texturemapping = _texturemapping;
		}
		
    	/**
    	 * Determines if texture bitmap is smoothed (bilinearly filtered) when drawn to screen.
    	 */
        public function get smooth():Boolean
        {
        	return _smooth;
        }
        
        public function set smooth(val:Boolean):void
        {
        	if (_smooth == val)
        		return;
        	
        	_smooth = val;
        	
        	_materialDirty = true;
        }
        
        /**
        * Determines if texture bitmap will tile in uv-space
        */
        public function get repeat():Boolean
        {
        	return _repeat;
        }
        
        public function set repeat(val:Boolean):void
        {
        	if (_repeat == val)
        		return;
        	
        	_repeat = val;
        	
        	_materialDirty = true;
        }
        
        
        /**
        * Corrects distortion caused by the affine transformation (non-perspective) of textures.
        * The number refers to the pixel correction value - ie. a value of 2 means a distorion correction to within 2 pixels of the correct perspective distortion.
        * 0 performs no precision.
        */
        public function get precision():Number
        {
        	return _precision;
        }
        
        public function set precision(val:Number):void
        {
        	_precision = val*val*1.4;
        	
        	_materialDirty = true;
        }
        
		/**
		 * Returns the width of the bitmapData being used as the material texture.
		 */
        public function get width():Number
        {
            return _bitmap.width;
        }
        
		/**
		 * Returns the height of the bitmapData being used as the material texture.
		 */
        public function get height():Number
        {
            return _bitmap.height;
        }
        
		/**
		 * Defines the bitmapData object being used as the material texture.
		 */
        public function get bitmap():BitmapData
        {
        	return _bitmap;
        }
        
        public function set bitmap(val:BitmapData):void
        {
        	_bitmap = val;
        	
        	_bitmapDirty = true;
        }
        
		/**
		 * Returns the argb value of the bitmapData pixel at the given u v coordinate.
		 */
        public function getPixel32(u:Number, v:Number):uint
        {
        	if (repeat) {
        		x = u%1;
        		y = (1 - v%1);
        	} else {
        		x = u;
        		y = (1 - v);
        	}
        	return _bitmap.getPixel32(x*_bitmap.width, y*_bitmap.height);
        }
        
		/**
		 * Defines a colored tint for the texture bitmap.
		 */
		public override function get color():uint
		{
			return _color;
		}
        public override function set color(val:uint):void
		{
			if (_color == val)
				return;
			
			_color = val;
            _red = ((_color & 0xFF0000) >> 16)/255;
            _green = ((_color & 0x00FF00) >> 8)/255;
            _blue = (_color & 0x0000FF)/255;
            
            _colorTransformDirty = true;
		}
        
        /**
        * Defines an alpha value for the texture bitmap.
        */
        public override function get alpha():Number
        {
            return _alpha;
        }
        
        public override function set alpha(value:Number):void
        {
            if (value > 1)
                value = 1;

            if (value < 0)
                value = 0;

            if (_alpha == value)
                return;

            _alpha = value;

            _colorTransformDirty = true;
        }
        
        /**
        * Defines a colortransform for the texture bitmap.
        */
        public function get colorTransform():ColorTransform
        {
            return _colorTransform;
        }
        
        public function set colorTransform(value:ColorTransform):void
        {
            _colorTransform = value;
			
			if (_colorTransform) {
				_red = _colorTransform.redMultiplier;
				_green = _colorTransform.greenMultiplier;
				_blue = _colorTransform.blueMultiplier;
				_alpha = _colorTransform.alphaMultiplier;
				
				_color = (_red*255 << 16) + (_green*255 << 8) + _blue*255;
			}
			
            _colorTransformDirty = true;
        }
        /**
        * Defines a blendMode value for the texture bitmap.
        * Applies to materials rendered as children of <code>BitmapMaterialContainer</code> or  <code>CompositeMaterial</code>.
        * 
        * @see away3d.materials.BitmapMaterialContainer
        * @see away3d.materials.CompositeMaterial
        */
        public function get blendMode():String
        {
        	return _blendMode;
        }
    	
        public function set blendMode(val:String):void
        {
        	if (_blendMode == val)
        		return;
        	
        	_blendMode = val;
        	_blendModeDirty = true;
        }
		
		/**
        * Displays the normals per face in pink lines.
        */
        public function get showNormals():Boolean
        {
        	return _showNormals;
        }
        
        public function set showNormals(val:Boolean):void
        {
        	if (_showNormals == val)
        		return;
        	
        	_showNormals = val;
        	
        	_materialDirty = true;
        }
        
		/**
		 * Creates a new <code>BitmapMaterial</code> object.
		 * 
		 * @param	bitmap				The bitmapData object to be used as the material's texture.
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public function BitmapMaterial(bitmap:BitmapData, init:Object = null)
        {
        	_renderBitmap = _bitmap = bitmap;
        	
        	ini = Init.parse(init);
        	wireColor = ini.getColor("wireColor", 0x0000FF);
        	
			super(ini);
			
            smooth = ini.getBoolean("smooth", false);
            debug = ini.getBoolean("debug", false);
            repeat = ini.getBoolean("repeat", false);
            _blendMode = ini.getString("blendMode", BlendMode.NORMAL);
            colorTransform = ini.getObject("colorTransform", ColorTransform) as ColorTransform;
            showNormals = ini.getBoolean("showNormals", false);
            
            _colorTransformDirty = true;
        }
    }
}