package {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	// Reference de format de Level Design Sokoban:
	// http://sokobano.de/wiki/index.php?title=Level_format
	// Le format du JSON est librement inspiré de cette référence
	
	public class LevelEditor extends MovieClip {
		
		private var content:Object = {};
		
		private var file:FileReference;
		
		public function LevelEditor() {
			file = new FileReference();
			stop();
			addEventListener(Event.ENTER_FRAME, doAction);
		}
		
		private function doAction(pEvent:Event):void {
			
			var i:uint;
			var ldID:uint;
			
			if (currentFrame > 1) {
				if (content.levelDesign == null) content.levelDesign = [];
				ldID = content.levelDesign.push({}) - 1;
			}
			
			// stockage des données texte
			for (i = 0; i < numChildren; i++) {
				if (getChildAt(i) is TextField) {
					var lDatas:Array = TextField(getChildAt(i)).text.split("\r");
					for (var j:uint = 0; j < lDatas.length; j++) {
						if (lDatas[j].indexOf(":") == -1) continue;
						if (currentFrame == 1) content[getName(lDatas[j])] = getValue(lDatas[j]);
						else content.levelDesign[ldID][getName(lDatas[j])] = getValue(lDatas[j]);
					}
				}
			}
			
			if (currentFrame == 1) {
				nextFrame();
				return;
			}
			
			content.levelDesign[ldID].map = [[0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0]];
			
			// stockage de la map
			for (i = 0; i < numChildren; i++) {
				var lPos:Point = getCell(getChildAt(i));
				
				if (getChildAt(i) is Wall) content.levelDesign[ldID].map[lPos.y][lPos.x] += 1;
				else if (getChildAt(i) is Goal) content.levelDesign[ldID].map[lPos.y][lPos.x] += 2;
				else if (getChildAt(i) is Player) content.levelDesign[ldID].map[lPos.y][lPos.x] += 3;
				else if (getChildAt(i) is Box) content.levelDesign[ldID].map[lPos.y][lPos.x] += 4;
				else if (getChildAt(i) is BoxOnRailHorizontal) content.levelDesign[ldID].map[lPos.y][lPos.x] += 5;
				else if (getChildAt(i) is BoxOnRailVertical) content.levelDesign[ldID].map[lPos.y][lPos.x] += 6;
				else if (getChildAt(i) is BoxOnTurningRailBottomLeft) content.levelDesign[ldID].map[lPos.y][lPos.x] += 7;
				else if (getChildAt(i) is BoxOnTurningRailBottomRight) content.levelDesign[ldID].map[lPos.y][lPos.x] += 8;
				else if (getChildAt(i) is BoxOnTurningRailTopLeft) content.levelDesign[ldID].map[lPos.y][lPos.x] += 9;
				else if (getChildAt(i) is BoxOnTurningRailTopRight) content.levelDesign[ldID].map[lPos.y][lPos.x] += 10;
				else if (getChildAt(i) is Cart) content.levelDesign[ldID].map[lPos.y][lPos.x] += 11;
				else if (getChildAt(i) is CartOnRailHorizontal) content.levelDesign[ldID].map[lPos.y][lPos.x] += 12;
				else if (getChildAt(i) is CartOnRailVertical) content.levelDesign[ldID].map[lPos.y][lPos.x] += 13;
				else if (getChildAt(i) is CartOnTurningRailBottomLeft) content.levelDesign[ldID].map[lPos.y][lPos.x] += 14;
				else if (getChildAt(i) is CartOnTurningRailBottomRight) content.levelDesign[ldID].map[lPos.y][lPos.x] += 15;
				else if (getChildAt(i) is CartOnTurningRailTopLeft) content.levelDesign[ldID].map[lPos.y][lPos.x] += 16;
				else if (getChildAt(i) is CartOnTurningRailTopRight) content.levelDesign[ldID].map[lPos.y][lPos.x] += 17;
				else if (getChildAt(i) is PlayerOnRailHorizontal) content.levelDesign[ldID].map[lPos.y][lPos.x] += 18;
				else if (getChildAt(i) is PlayerOnRailVertical) content.levelDesign[ldID].map[lPos.y][lPos.x] += 19;
				else if (getChildAt(i) is PlayerOnTurningRailBottomLeft) content.levelDesign[ldID].map[lPos.y][lPos.x] += 20;
				else if (getChildAt(i) is PlayerOnTurningRailBottomRight) content.levelDesign[ldID].map[lPos.y][lPos.x] += 21;
				else if (getChildAt(i) is PlayerOnTurningRailTopLeft) content.levelDesign[ldID].map[lPos.y][lPos.x] += 22;
				else if (getChildAt(i) is PlayerOnTurningRailTopRight) content.levelDesign[ldID].map[lPos.y][lPos.x] += 23;
				else if (getChildAt(i) is RailHorizontal) content.levelDesign[ldID].map[lPos.y][lPos.x] += 24;
				else if (getChildAt(i) is RailVertical) content.levelDesign[ldID].map[lPos.y][lPos.x] += 25;
				else if (getChildAt(i) is TurningRailBottomLeft) content.levelDesign[ldID].map[lPos.y][lPos.x] += 26;
				else if (getChildAt(i) is TurningRailBottomRight) content.levelDesign[ldID].map[lPos.y][lPos.x] += 27;
				else if (getChildAt(i) is TurningRailTopLeft) content.levelDesign[ldID].map[lPos.y][lPos.x] += 28;
				else if (getChildAt(i) is TurningRailTopRight) content.levelDesign[ldID].map[lPos.y][lPos.x] += 29;
				else if (getChildAt(i) is TripleRail) content.levelDesign[ldID].map[lPos.y][lPos.x] += 30;
			}
			
			convertMap(content.levelDesign[ldID].map);
			
			if (currentFrame == totalFrames) {
				removeEventListener(Event.ENTER_FRAME, doAction);
				var lData:ByteArray = new ByteArray();
				lData.writeMultiByte(JSON.stringify(content, null, "\t"), "utf-8");
				file.save(lData, "leveldesign.json");
				
			} else nextFrame();
		
		}
		
		private function getCell(pItem:DisplayObject):Point {
			return new Point(Math.round(pItem.x / 100), Math.round(pItem.y / 100));
		}
		
		// supprime les espaces devant et derrière
		private function trim(pValue:String):String {
			return pValue.replace(/^[ ]+|[ ]+$/, "");
		}
		
		private function getName(pValue:String):String {
			return trim(pValue.split(":")[0]);
		}
		
		// supprime les espaces devant et derrière le nom de la variable
		private function getValue(pValue:String):* {
			var lValue:String = trim(pValue.split(":")[1]);
			if (lValue == "true") return true;
			else if (lValue == "false") return false;
			else if (!isNaN(parseFloat(lValue))) return parseFloat(lValue);
			return lValue;
		}
		
		// conversion des valeurs numériques de la map en string
		private function convertMap(pMap:Array):void {
			for (var i:int = 0; i < 9; i++) {
				for (var j:int = 0; j < 9; j++) {
					if (pMap[i][j] == 0) pMap[i][j] = " ";
					else if (pMap[i][j] == 1) pMap[i][j] = "$";
					else if (pMap[i][j] == 2) pMap[i][j] = "t";
					else if (pMap[i][j] == 3) pMap[i][j] = "#";
					else if (pMap[i][j] == 4) pMap[i][j] = ".";
					else if (pMap[i][j] == 5) pMap[i][j] = "m";
					else if (pMap[i][j] == 6) pMap[i][j] = "l";
					else if (pMap[i][j] == 7) pMap[i][j] = "c";
					else if (pMap[i][j] == 8) pMap[i][j] = "v";
					else if (pMap[i][j] == 9) pMap[i][j] = "w";
					else if (pMap[i][j] == 10) pMap[i][j] = "x";
					else if (pMap[i][j] == 11) pMap[i][j] = "y";
					else if (pMap[i][j] == 12) pMap[i][j] = "i";
					else if (pMap[i][j] == 13) pMap[i][j] = "u";
					else if (pMap[i][j] == 14) pMap[i][j] = "q";
					else if (pMap[i][j] == 15) pMap[i][j] = "s";
					else if (pMap[i][j] == 16) pMap[i][j] = "o";
					else if (pMap[i][j] == 17) pMap[i][j] = "p";
					else if (pMap[i][j] == 18) pMap[i][j] = "f";
					else if (pMap[i][j] == 19) pMap[i][j] = "d";
					else if (pMap[i][j] == 20) pMap[i][j] = "j";
					else if (pMap[i][j] == 21) pMap[i][j] = "k";
					else if (pMap[i][j] == 22) pMap[i][j] = "g";
					else if (pMap[i][j] == 23) pMap[i][j] = "h";
					else if (pMap[i][j] == 24) pMap[i][j] = "&";
					else if (pMap[i][j] == 25) pMap[i][j] = "@";
					else if (pMap[i][j] == 26) pMap[i][j] = "e";
					else if (pMap[i][j] == 27) pMap[i][j] = "r";
					else if (pMap[i][j] == 28) pMap[i][j] = "a";
					else if (pMap[i][j] == 29) pMap[i][j] = "z";
					else if (pMap[i][j] == 30) pMap[i][j] = "n";
				}
				pMap[i] = pMap[i].join("");
			}
		}
	
	}

}
