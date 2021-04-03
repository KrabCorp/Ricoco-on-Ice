package  {
	
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.display.DisplayObjectContainer;
	import flash.net.FileReference;
	import flash.utils.ByteArray;	
	
	public class ExportColliders extends MovieClip {
		
		private var content:Object;
		private var file: FileReference;
		
		public function ExportColliders() {
			
			content={};
			file = new FileReference();
			
			var lCollider;
			// constructor code
			for (var i:int = 0; i<numChildren;i++) {
				lCollider=getChildAt(i);
				if (lCollider is DisplayObjectContainer) {
					content[getQualifiedClassName(lCollider)]={};
					browseCollider (content[getQualifiedClassName(lCollider)],lCollider);
				}
			}
			
			
			//trace (JSON.stringify(content,null,"\t"));
			
			var lData:ByteArray = new ByteArray();
			lData.writeMultiByte(JSON.stringify(content,null,"\t"), "utf-8" );
			file.save(lData, "colliders.json" );

		}
		
		private function browseCollider (pContent:Object,pClip:DisplayObjectContainer): void {
			var lItem;
			
			for (var i:int=0;i<pClip.numChildren;i++) {
				lItem=pClip.getChildAt(i);
				
				var lClass:String=getQualifiedClassName(lItem);
		
				if (lClass!="Circle" && lClass!="Rectangle" && lClass!="Point") continue;
				
				if (lClass=="Circle" && Math.abs(lItem.width-lItem.height)>1) lClass="Ellipse";
				
				if (lClass=="Rectangle" || lClass == "Ellipse") setItem(pContent,lItem.name,lItem.getBounds(pClip).left,lItem.getBounds(pClip).top,lClass);
				else setItem(pContent,lItem.name,lItem.x,lItem.y,lClass);
				
				if (lClass=="Ellipse" || lClass=="Rectangle") {
					pContent[lItem.name].width=lItem.width;
					pContent[lItem.name].height=lItem.height;
				} else if (lClass=="Circle") pContent[lItem.name].radius=lItem.width/2;
	
			}
			
		}
		
		private function setItem (pContent:Object,pName:String,pX:Number,pY:Number,pType:String): void {
			pContent[pName]={};
			pContent[pName].x=pX;
			pContent[pName].y=pY;
			pContent[pName].type=pType;
		}
		
	}
	
}
