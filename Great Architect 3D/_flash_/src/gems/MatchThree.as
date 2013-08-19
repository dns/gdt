﻿package gems {	import alternativa.engine3d.core.Camera3D;	import alternativa.engine3d.core.Object3D;	import alternativa.engine3d.core.Resource;	import alternativa.engine3d.core.View;	import alternativa.engine3d.lights.AmbientLight;	import alternativa.engine3d.lights.DirectionalLight;	import alternativa.engine3d.lights.OmniLight;	import alternativa.engine3d.loaders.events.TexturesLoaderEvent;	import alternativa.engine3d.loaders.Parser3DS;	import alternativa.engine3d.loaders.ParserMaterial;	import alternativa.engine3d.loaders.TexturesLoader;	import alternativa.engine3d.materials.FillMaterial;	import alternativa.engine3d.materials.StandardMaterial;	import alternativa.engine3d.materials.TextureMaterial;	import alternativa.engine3d.objects.Mesh;	import alternativa.engine3d.objects.Surface;	import alternativa.engine3d.primitives.Box;	import alternativa.engine3d.primitives.GeoSphere;	import alternativa.engine3d.primitives.Plane;	import alternativa.engine3d.resources.BitmapTextureResource;	import alternativa.engine3d.resources.ExternalTextureResource;	import alternativa.engine3d.resources.TextureResource;	import alternativa.engine3d.shadows.DirectionalLightShadow;	import alternativa.engine3d.core.events.MouseEvent3D;	import flash.display.BitmapData;	import flash.display.Sprite;	import flash.display.Stage3D;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.utils.Dictionary;	import flash.utils.getTimer;	import flash.utils.setTimeout;	import com.greensock.easing.Linear;	import com.greensock.TweenMax;	import com.greensock.easing.Back;		public class MatchThree extends Sprite 	{		// constants		public const numPieces		: uint = 5;		public const spacing		: Number = 25;		public const offsetX		: Number = 0;		public const offsetY		: Number = 0;				// game grid and mode		private var grid			: Array;		private var rows			: int = 7;		private var columns			: int = 7;		//		private var isFalling		: Boolean = false;		private var isUnchain		: Boolean = false;		public var ready			: Boolean = false;		//		private var firstPiece		: BaseGem;				private var rootContainer	: Object3D = new Object3D();				private var camera			: Camera3D;		private var stage3D			: Stage3D;		private var sphere			: GeoSphere;		//		public function MatchThree(_stage3D:Stage3D) 		{				stage3D = _stage3D;			//			addEventListener(Event.ADDED_TO_STAGE, init);		}		//		private function init(e:Event):void 		{			removeEventListener(Event.ADDED_TO_STAGE, init);			//			camera = new Camera3D(0.1, 100000);			camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);			camera.view.hideLogo();			addChild(camera.view);			//			camera.rotationX = -90 * Math.PI / 180;			camera.x = 50;			camera.y = -400;			camera.z = -100;			rootContainer.addChild(camera);		}				public function renderEvent():void 		{			if (!ready) { return; }			//			camera.view.width = stage.stageWidth;			camera.view.height = stage.stageHeight;			//			camera.render(stage3D);		}				public function startMatchThree():void 		{			while (true) 			{				grid = new Array();				for (var gridrows:int = 0; gridrows < rows; gridrows++) 					grid.push(new Vector.<BaseGem>);								for (var col:int = 0; col < columns; col++) 				{					for (var row:int = 0; row < rows; row++)					{						addPiece(col, row);					}				}								if (lookForMatches().length != 0) continue;								if (lookForPossibles() == false) continue;								break;			} 						for (var col:int = 0; col < columns; col++) 			{				for (var row:int = 0; row < rows; row++)				{					rootContainer.addChild(grid[col][row]);				}			}			for each (var resource:Resource in rootContainer.getResources(true)) 			{				resource.upload(stage3D.context3D);			}						ready = true;		}				private function addPiece(col:int, row:int):BaseGem 		{			var newPiece:BaseGem = new BaseGem(10, 5);			newPiece.type = Math.ceil(Math.random() * numPieces);						var material:FillMaterial;						switch(newPiece.type) 			{				case 1:					material = new FillMaterial(0xFF2255);					break;				case 2:					material = new FillMaterial(0x80FFFF);					break;				case 3:					material = new FillMaterial(0x0080FF);					break;				case 4:					material = new FillMaterial(0x000080);					break;				case 5:					material = new FillMaterial(0xFFFF80);					break;			}						newPiece.setMaterialToAllSurfaces(material);						newPiece.x = col * spacing + offsetX;			newPiece.y = -200;			newPiece.z = -(row * spacing + offsetY);			newPiece.col = col;			newPiece.row = row;			grid[col][row] = newPiece;			newPiece.addEventListener(MouseEvent3D.CLICK, clickPiece);			return newPiece;		}				private function clickPiece(event:MouseEvent3D):void 		{			var piece:BaseGem = BaseGem(event.target);						if (piece.isLocked || piece.isWall || isFalling)				return;						if (firstPiece == null) 			{				firstPiece = piece;				firstPiece.select(true);			} 			else if (firstPiece == piece) 			{				firstPiece.select();				firstPiece = null;			} 			else 			{				if (((firstPiece.row == piece.row) && (Math.abs(firstPiece.col - piece.col) == 1)) ||				((firstPiece.col == piece.col) && (Math.abs(firstPiece.row - piece.row) == 1))) 				{					makeSwap(firstPiece, piece);					firstPiece.select();					firstPiece = null;				}  				else 				{					firstPiece.select();					firstPiece = null;					firstPiece = piece;					firstPiece.select(true);				}			}		}				private function makeSwap(piece1:BaseGem, piece2:BaseGem):void 		{			swapPieces(piece1, piece2);						if (lookForMatches().length == 0) 			{				swapPieces(piece1, piece2);				errorSwapping(piece1, piece2);			}			else				swapping(piece1, piece2);		}				private function swapPieces(piece1:BaseGem, piece2:BaseGem):void 		{			var tempCol:uint = piece1.col;			var tempRow:uint = piece1.row;			piece1.col = piece2.col;			piece1.row = piece2.row;			piece2.col = tempCol;			piece2.row = tempRow;						grid[piece1.col][piece1.row] = piece1;			grid[piece2.col][piece2.row] = piece2;					}				private function swapping(piece1:BaseGem, piece2:BaseGem):void 		{			TweenMax.to(piece1, 0.3, { x:piece1.col * spacing + offsetX, z:-(piece1.row * spacing + offsetY), onComplete:findAndRemoveMatches } );			TweenMax.to(piece2, 0.3, { x:piece2.col * spacing + offsetX, z:-(piece2.row * spacing + offsetY) } );		}				private function errorSwapping(piece1:BaseGem, piece2:BaseGem):void 		{			TweenMax.to(piece1, 0.3, { x:piece2.col * spacing + offsetX, z:-(piece2.row * spacing + offsetY), onComplete:piece1Back, onCompleteParams:[piece1], ease:Linear.easeIn } );			TweenMax.to(piece2, 0.3, { x:piece1.col * spacing + offsetX, z:-(piece1.row * spacing + offsetY), onComplete:piece2Back, onCompleteParams:[piece2], ease:Linear.easeIn } );		}				private function piece1Back(piece:BaseGem):void 		{			TweenMax.to(piece, 0.3, { x:piece.col * spacing + offsetX, z:-(piece.row * spacing + offsetY), ease:Linear.easeOut } );		}				private function piece2Back(piece:BaseGem):void 		{			TweenMax.to(piece, 0.3, { x:piece.col * spacing + offsetX, z:-(piece.row * spacing + offsetY), ease:Linear.easeOut } );		}				private function findAndRemoveMatches():void 		{			var matches:Array = lookForMatches();			if (matches.length == 0)			{				isFalling = false;								if (isUnchain)					generateNewGems();								//if (!lookForPossibles()) 				//	endGame();									return;			}						for (var i:int = 0; i < matches.length; i++) 			{				for (var j:int = 0; j < matches[i].length; j++) 				{					if (grid[matches[i][j].col][matches[i][j].row])					{						if (matches[i][j].isLocked)						{							isUnchain = true;							matches[i][j].unchained();							affectAbove(matches[i][j]);						}						else						{							isFalling = true;							grid[matches[i][j].col][matches[i][j].row] = null;							deletePiece(matches[i][j]);						}					}				}			}		}		//		private function deletePiece(piece:BaseGem):void 		{			rootContainer.removeChild(piece);			affectAbove(piece);		}		//		private function lookForMatches():Array 		{			var matchList:Array = new Array();			for (var row:int = 0; row < rows; row++) 			{				for (var col:int = 0; col < columns; col++) 				{					var match:Array = getMatchHoriz(col, row);					if (match.length > 2) 					{						matchList.push(match);						break;					}				}			}			for (col = 0; col < columns; col++) 			{				for (row = 0; row < rows; row++) 				{					match = getMatchVert(col, row);					if (match.length > 2) 					{						matchList.push(match);						break;					}					}			}						return matchList;		}				private function getMatchHoriz(col:int, row:int):Array 		{			var match:Array = new Array(grid[col][row]);			for (var i:int = 1; col + i < columns; i++) 			{				if (grid[col][row] != null && grid[col + i][row] != null && grid[col][row].type == grid[col + i][row].type)					match.push(grid[col + i][row]);				else					return match;			}			return match;		}		private function getMatchVert(col:int, row:int):Array 		{			var match:Array = new Array(grid[col][row]);			for (var i:int = 1; row + i < rows; i++) 			{				if (grid[col][row] != null && grid[col][row + i] != null && grid[col][row].type == grid[col][row + i].type)					match.push(grid[col][row + i]);				else 					return match;			}			return match;		}				private function affectAbove(piece:BaseGem):void 		{			if (isUnchain)			{				var row:int = piece.row;				while (row >= 0) 				{					if (grid[piece.col][row] != null && !grid[piece.col][row].isLocked && !grid[piece.col][row].isWall)					{						var rowAdd:int = row + 1;						while(grid[piece.col][rowAdd] == null)						{							(grid[piece.col][rowAdd - 1] as BaseGem).row++;							grid[piece.col][rowAdd] = grid[piece.col][rowAdd - 1];							grid[piece.col][rowAdd - 1] = null;							TweenMax.to(grid[piece.col][rowAdd], 0.5, { x:(grid[piece.col][rowAdd] as BaseGem).col * spacing + offsetX, z:-((grid[piece.col][rowAdd] as BaseGem).row * spacing + offsetY) } );													rowAdd++;						}					}					row--;				}			}			else			{				var row:int = piece.row - 1;				while (row >= 0) 				{					if (grid[piece.col][row] != null && !grid[piece.col][row].isLocked && !grid[piece.col][row].isWall)					{						(grid[piece.col][row] as BaseGem).row++;						grid[piece.col][row + 1] = grid[piece.col][row];						grid[piece.col][row] = null;						TweenMax.to(grid[piece.col][row + 1], 0.5, { x:(grid[piece.col][row + 1] as BaseGem).col * spacing + offsetX, z:-((grid[piece.col][row + 1] as BaseGem).row * spacing + offsetY) } );											row--;					}					else						break;				}			}						addNewPiece(piece.col, row + 1);		}				private function addNewPiece(col:int, index:int):void 		{				if (index == 0 && !isUnchain) 			{				var newPiece:BaseGem = addPiece(col, index);				newPiece.z = spacing * (rows - index);								rootContainer.addChild(newPiece);				for each (var resource:Resource in rootContainer.getResources(true)) 				{					resource.upload(stage3D.context3D);				}								TweenMax.to(newPiece, (index + 1) / 2, { x:newPiece.col * spacing + offsetX, z:-(newPiece.row * spacing + offsetY), onComplete:findAndRemoveMatches } );			}			else				findAndRemoveMatches();		}				private function generateNewGems():void 		{				for (var col:int = 0; col < columns; col++) 			{				for (var row:int = rows - 1; row >= 0; row--)				{					if (grid[col][row] == null)					{						var newPiece:BaseGem = addPiece(col, row);						newPiece.y = -spacing * (rows - row);						TweenMax.to(newPiece, (row + 1) / 2, { x:newPiece.col * spacing + offsetX, z:newPiece.row * spacing + offsetY } );					}				}			}						isUnchain = false;		}				private function lookForPossibles():Boolean 		{			for (var col:int = 0; col < columns; col++) 			{				for (var  row:int = 0; row < rows; row++)				{					if (grid[col][row].type == 7)					return true;					if (matchPattern(col, row, [[1, 0]], [[ -2, 0], [ -1, -1], [ -1, 1], [2, -1], [2, 1], [3, 0]])) 						return true;					if (matchPattern(col, row, [[2, 0]], [[1, -1], [1, 1]])) 						return true;					if (matchPattern(col, row, [[0, 1]], [[0, -2], [ -1, -1], [1, -1], [ -1, 2], [1, 2], [0, 3]])) 						return true;					if (matchPattern(col, row, [[0, 2]], [[ -1, 1], [1, 1]])) 						return true;				}			}			return false;		}		//		//		private function matchPattern(col:int, row:uint, mustHave:Array, needOne:Array):Boolean 		{			var thisType:int = grid[col][row].type;			for (var i:int = 0; i < mustHave.length; i++) 			{				if (!matchType(col + mustHave[i][0], row + mustHave[i][1], thisType)) 					return false;			}			for (i = 0; i < needOne.length; i++) 			{				if (matchType(col + needOne[i][0], row + needOne[i][1], thisType)) 					return true;			}			return false;		}				private function matchType(col:int, row:int, type:int):Boolean 		{			if ((col < 0) || (col > columns - 1) || (row < 0) || (row > rows - 1)) return false;			return (grid[col][row].type == type);		}				private function endGame():void 		{					}	}}